const std = @import("std");
const builtin = @import("builtin");
const build_options = @import("build_options");
const mach = @import("mach");
const Camera = @import("Camera.zig");
const Renderer = @import("Renderer.zig");
const Object = @import("Object.zig");
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

pub const local_events = .{
    .render = .{ .handler = render },
};

pipeline: *gpu.RenderPipeline = undefined,
bind_group: *gpu.BindGroup = undefined,
camera_uniform_buf: *gpu.Buffer = undefined,
show_points: bool = builtin.mode == .Debug,

// TODO: DON"T DEPENED ON OBJECT
pub fn init(light: *Light, object: *Object) !void {
    const shader_module = mach.core.device.createShaderModuleWGSL("light", @embedFile("shaders/light.wgsl"));
    defer shader_module.release();

    const camera_uniform_buf = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(shaders.CameraUniform2),
        .mapped_at_creation = .false,
    });

    const bind_group_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{ .entries = &.{
            gpu.BindGroupLayout.Entry.buffer(0, .{ .vertex = true }, .uniform, false, @sizeOf(shaders.CameraUniform)),
            gpu.BindGroupLayout.Entry.buffer(1, .{ .vertex = true, .fragment = true }, .uniform, false, @sizeOf(shaders.LightBuffer)),
        } }),
    );
    defer bind_group_layout.release();

    const bind_group = mach.core.device.createBindGroup(
        &gpu.BindGroup.Descriptor.init(.{
            .layout = bind_group_layout,
            .entries = &.{
                gpu.BindGroup.Entry.buffer(0, camera_uniform_buf, 0, @sizeOf(shaders.CameraUniform)),
                gpu.BindGroup.Entry.buffer(1, object.lights_buffer, 0, @sizeOf(shaders.LightBuffer)),
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
            }},
        }),
        .vertex = gpu.VertexState.init(.{
            .module = shader_module,
            .entry_point = "vertex_main",
        }),
    };
    const pipeline = mach.core.device.createRenderPipeline(&pipeline_descriptor);

    light.* = .{
        .pipeline = pipeline,
        .bind_group = bind_group,
        .camera_uniform_buf = camera_uniform_buf,
    };
}

pub fn deinit(light: *Mod) !void {
    const state = light.state();

    state.bind_group.release();
}

pub fn render(light: *Mod, renderer: *Renderer.Mod, camera: Camera) !void {
    const state: *Light = light.state();
    const renderer_state: *Renderer = renderer.state();

    mach.core.queue.writeBuffer(state.camera_uniform_buf, 0, &[_]shaders.CameraUniform2{.{
        .view = camera.view,
        .projection_view = camera.projection.mul(&camera.view),
    }});

    if (!state.show_points) return;

    renderer_state.deferred_pass.setPipeline(state.pipeline);
    renderer_state.deferred_pass.setBindGroup(0, state.bind_group, &.{});
    // renderer_state.deferred_pass.draw(6, 1, 0, 0);

    // TODO: LOOKS CURSED
    var archetypes_iter = light.entities.query(.{ .all = &.{.{ .light = &.{ .position, .color, .radius } }} });
    while (archetypes_iter.next()) |archetype| {
        renderer_state.deferred_pass.draw(6, @intCast(archetype.slice(.light, .position).len), 0, 0);
    }
}
