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
// TODO: lights are always rendered over objects.
//       figure out how to apply depth correctly,
//       and change this to `builtin.mode == .Debug`
show_points: bool = true,

pub fn init(light: *Light, renderer: *Renderer) !void {
    const shader_module = mach.core.device.createShaderModuleWGSL("light", @embedFile("shaders/light.wgsl"));
    defer shader_module.release();

    const bind_group_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{ .entries = &.{
            gpu.BindGroupLayout.Entry.buffer(0, .{ .vertex = true }, .uniform, false, @sizeOf(shaders.CameraUniform)),
            gpu.BindGroupLayout.Entry.buffer(1, .{ .vertex = true, .fragment = true }, .uniform, false, @sizeOf(shaders.LightBuffer)),
            gpu.BindGroupLayout.Entry.texture(2, .{ .fragment = true }, .depth, .dimension_2d, false),
        } }),
    );
    defer bind_group_layout.release();

    const bind_group = mach.core.device.createBindGroup(
        &gpu.BindGroup.Descriptor.init(.{
            .layout = bind_group_layout,
            .entries = &.{
                .{ .binding = 0, .buffer = renderer.camera_uniform, .size = @sizeOf(shaders.CameraUniform) },
                .{ .binding = 1, .buffer = renderer.lights_buffer, .size = @sizeOf(shaders.LightBuffer) },
                .{ .binding = 2, .texture_view = renderer.depth_view, .size = 0 },
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

    light.* = .{ .pipeline = pipeline, .bind_group = bind_group };
}

pub fn deinit(light: *Mod) !void {
    const state = light.state();

    state.bind_group.release();
}

pub fn render(light: *Mod, renderer: *Renderer.Mod) !void {
    const state: *Light = light.state();
    const renderer_state: *Renderer = renderer.state();

    if (!state.show_points) return;

    renderer_state.quad_pass.setPipeline(state.pipeline);
    renderer_state.quad_pass.setBindGroup(0, state.bind_group, &.{});

    var instances: u32 = 0;
    var archetypes_iter = light.entities.query(.{ .all = &.{.{ .light = &.{ .position, .color, .radius } }} });
    while (archetypes_iter.next()) |archetype| instances += @intCast(archetype.archetype.len);
    renderer_state.quad_pass.draw(6, instances, 0, 0);
}
