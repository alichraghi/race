const std = @import("std");
const builtin = @import("builtin");
const build_options = @import("build_options");
const mach = @import("mach");
const Camera = @import("Camera.zig");
const Renderer = @import("Renderer.zig");
const math = @import("math.zig");
const shaders = @import("shaders.zig");
const gpu = mach.gpu;
const Vec3 = math.Vec3;
const Vec4 = math.Vec4;

const Light = @This();

pub const name = .light;
pub const Mod = mach.Mod(Light);

pub const components = .{
    .position = .{ .type = Vec3 },
    .color = .{ .type = Vec4 },
    .radius = .{ .type = f32 },
};

pub const events = .{
    .render = .{ .handler = render },
};

pipeline: *gpu.RenderPipeline,
camera_uniform_buf: *gpu.Buffer,
light_uniform_buf: *gpu.Buffer,
light_uniform_stride: u32,
bind_group: *gpu.BindGroup,
show_points: bool = builtin.mode == .Debug,

pub fn init(state: *Light, renderer_state: *Renderer) !void {
    const shader_module = mach.core.device.createShaderModuleWGSL("light", @embedFile("shaders/light.wgsl"));
    defer shader_module.release();

    const camera_uniform_buf = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(shaders.CameraUniform),
        .mapped_at_creation = .false,
    });

    const min_uniform_alignment = renderer_state.limits.limits.min_uniform_buffer_offset_alignment;
    const light_uniform_stride = math.uniformStride(shaders.LightUniform, min_uniform_alignment);
    const light_uniform_buf = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = shaders.max_lights * light_uniform_stride,
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
                // TODO(sysgpu)
                if (build_options.use_sysgpu)
                    gpu.BindGroup.Entry.buffer(0, camera_uniform_buf, 0, @sizeOf(shaders.CameraUniform), 0)
                else
                    gpu.BindGroup.Entry.buffer(0, camera_uniform_buf, 0, @sizeOf(shaders.CameraUniform)),
                if (build_options.use_sysgpu)
                    gpu.BindGroup.Entry.buffer(1, light_uniform_buf, 0, light_uniform_stride, 0)
                else
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

    state.* = .{
        .pipeline = pipeline,
        .camera_uniform_buf = camera_uniform_buf,
        .light_uniform_buf = light_uniform_buf,
        .light_uniform_stride = light_uniform_stride,
        .bind_group = bind_group,
    };
}

fn deinit(light: *Mod) !void {
    const state = light.state();

    state.bind_group.release();
    state.camera_uniform_buf.release();
    state.light_uniform_buf.release();
}

fn render(light: *Mod, renderer: *Renderer.Mod, camera: Camera) !void {
    const state = light.state();
    const renderer_state = renderer.state();

    if (!state.show_points) return;

    renderer_state.pass.setPipeline(state.pipeline);

    mach.core.queue.writeBuffer(
        state.camera_uniform_buf,
        0,
        &[_]shaders.CameraUniform{.{
            .projection = camera.projection,
            .view = camera.view,
        }},
    );

    var archetypes_iter = light.entities.query(.{ .all = &.{.{ .light = &.{ .position, .color, .radius } }} });
    while (archetypes_iter.next()) |archetype| {
        for (
            archetype.slice(.light, .position),
            archetype.slice(.light, .color),
            archetype.slice(.light, .radius),
            0..,
        ) |position, color, radius, i| {
            const buffer_offset = @as(u32, @intCast(i)) * state.light_uniform_stride;
            mach.core.queue.writeBuffer(
                state.light_uniform_buf,
                buffer_offset,
                &[_]shaders.LightUniform{.{
                    .position = position, // TODO: x is reverted!?
                    .color = color,
                    .radius = radius,
                }},
            );
            renderer_state.pass.setBindGroup(0, state.bind_group, &.{buffer_offset});
            renderer_state.pass.draw(6, 1, 0, 0);
        }
    }
}
