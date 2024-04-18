const std = @import("std");
const mach = @import("mach");
const Model = @import("Model.zig");
const Camera = @import("Camera.zig");
const Game = @import("Game.zig");
const math = @import("math.zig");
const gpu = mach.core.gpu;
const Vec3 = math.Vec3;
const Vec4 = math.Vec4;
const Mat3x3 = math.Mat3x3;
const Mat4x4 = math.Mat4x4;
const vec3 = math.vec3;
const vec4 = math.vec4;
const mat3x3 = math.mat3x3;
const mat4x4 = math.mat4x4;

pub const name = .light;
pub const Mod = mach.Mod(@This());

pub const components = .{
    .position = .{ .type = Vec3 },
    .color = .{ .type = Vec4 },
    .radius = .{ .type = f32 },
};

pub const local_events = .{
    .render = .{ .handler = render },
};

pipeline: *gpu.RenderPipeline,
camera_uniform_buf: *gpu.Buffer,
light_uniform_buf: *gpu.Buffer,
light_uniform_stride: u32,
bind_group: *gpu.BindGroup,
show_points: bool,

pub const Uniform = struct {
    position: Vec3,
    color: Vec4,
    radius: f32,
};

pub fn init(light: *@This(), lights_capacity: u32, show_points: bool) !void {
    const shader_module = mach.core.device.createShaderModuleWGSL("light.wgsl", @embedFile("light.wgsl"));
    defer shader_module.release();

    var limits = gpu.SupportedLimits{};
    _ = mach.core.device.getLimits(&limits);

    const camera_uniform_size = math.ceilToNextMultiple(
        @sizeOf(Camera.Uniform),
        limits.limits.min_uniform_buffer_offset_alignment,
    );
    const camera_uniform_buf = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = camera_uniform_size,
        .mapped_at_creation = .false,
    });

    const light_uniform_stride = math.ceilToNextMultiple(
        @sizeOf(Uniform),
        limits.limits.min_uniform_buffer_offset_alignment,
    );
    const light_uniform_buf = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = lights_capacity * light_uniform_stride,
        .mapped_at_creation = .false,
    });

    const bind_group_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{ .entries = &.{
            gpu.BindGroupLayout.Entry.buffer(0, .{ .vertex = true }, .uniform, false, 0),
            gpu.BindGroupLayout.Entry.buffer(1, .{ .vertex = true, .fragment = true }, .uniform, true, 0),
        } }),
    );
    defer bind_group_layout.release();

    const bind_group = mach.core.device.createBindGroup(
        &gpu.BindGroup.Descriptor.init(.{
            .layout = bind_group_layout,
            .entries = &.{
                gpu.BindGroup.Entry.buffer(0, camera_uniform_buf, 0, camera_uniform_size),
                gpu.BindGroup.Entry.buffer(1, light_uniform_buf, 0, light_uniform_stride),
            },
        }),
    );

    const pipeline_layout = mach.core.device.createPipelineLayout(
        &gpu.PipelineLayout.Descriptor.init(.{ .bind_group_layouts = &.{bind_group_layout} }),
    );

    const pipeline_descriptor = gpu.RenderPipeline.Descriptor{
        .layout = pipeline_layout,
        .fragment = &gpu.FragmentState.init(.{
            .module = shader_module,
            .entry_point = "frag_main",
            .targets = &.{.{
                .format = mach.core.descriptor.format,
                .blend = &.{
                    .color = .{
                        .operation = .add,
                        .src_factor = .src_alpha,
                        .dst_factor = .one_minus_src_alpha,
                    },
                },
                .write_mask = gpu.ColorWriteMaskFlags.all,
            }},
        }),
        .vertex = gpu.VertexState.init(.{
            .module = shader_module,
            .entry_point = "vertex_main",
            .buffers = &.{},
        }),
        .primitive = .{},
        .depth_stencil = &.{
            .format = .depth24_plus,
            .depth_write_enabled = .true,
            .depth_compare = .less,
        },
    };
    const pipeline = mach.core.device.createRenderPipeline(&pipeline_descriptor);

    light.* = .{
        .pipeline = pipeline,
        .camera_uniform_buf = camera_uniform_buf,
        .light_uniform_buf = light_uniform_buf,
        .light_uniform_stride = light_uniform_stride,
        .bind_group = bind_group,
        .show_points = show_points,
    };
}

pub fn deinit(light: *Mod) !void {
    light.state().bind_group.release();
    light.state().camera_uniform_buf.release();
    light.state().light_uniform_buf.release();
}

pub fn render(game: *Game.Mod, core: *mach.Core.Mod, light: *Mod, camera_mod: *Camera.Mod, camera: mach.EntityID) !void {
    if (!light.state().show_points) return;

    game.state().pass.setPipeline(light.state().pipeline);

    mach.core.queue.writeBuffer(
        light.state().camera_uniform_buf,
        0,
        &[_]Camera.Uniform{.{
            .projection = camera_mod.get(camera, .projection).?,
            .view = camera_mod.get(camera, .view).?,
        }},
    );

    var archetypes_iter = core.entities.query(.{ .all = &.{.{ .light = &.{ .position, .color, .radius } }} });
    while (archetypes_iter.next()) |archetype| {
        for (
            archetype.slice(.light, .position),
            archetype.slice(.light, .color),
            archetype.slice(.light, .radius),
            0..,
        ) |position, color, radius, i| {
            const buffer_offset = @as(u32, @intCast(i)) * light.state().light_uniform_stride;
            mach.core.queue.writeBuffer(
                light.state().light_uniform_buf,
                buffer_offset,
                &[_]Uniform{.{
                    .position = position, // TODO: x is reverted!?
                    .color = color,
                    .radius = radius,
                }},
            );
            game.state().pass.setBindGroup(0, light.state().bind_group, &.{buffer_offset});
            game.state().pass.draw(6, 1, 0, 0);
        }
    }
}
