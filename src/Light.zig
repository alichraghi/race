const std = @import("std");
const mach = @import("mach");
const Model = @import("Model.zig");
const Camera = @import("Camera.zig");
const math = @import("math.zig");
const core = mach.core;
const Engine = mach.Engine;
const gpu = core.gpu;
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

pub const components = struct {
    pub const position = Vec3;
    pub const color = Vec4;
};

pipeline: *gpu.RenderPipeline,
uniform_buf: *gpu.Buffer,
bind_group_layout: *gpu.BindGroupLayout,
bind_group: *gpu.BindGroup,
uniform_stride: u32,

pub const UBO = extern struct {
    projection: Mat4x4,
    view: Mat4x4,
    light_position: Vec3,
    light_color: Vec4,

    pub const bind_group_layout_entry = gpu.BindGroupLayout.Entry.buffer(
        0,
        .{ .vertex = true, .fragment = true },
        .uniform,
        true,
        0,
    );
};

pub const local = struct {
    pub fn init(light: *Mod, lights_capacity: u32) !void {
        const shader_module = core.device.createShaderModuleWGSL("light.wgsl", @embedFile("light.wgsl"));
        defer shader_module.release();

        const blend = gpu.BlendState{};
        const color_target = gpu.ColorTargetState{
            .format = core.descriptor.format,
            .blend = &blend,
            .write_mask = gpu.ColorWriteMaskFlags.all,
        };
        const fragment = gpu.FragmentState.init(.{
            .module = shader_module,
            .entry_point = "frag_main",
            .targets = &.{color_target},
        });

        var limits = gpu.SupportedLimits{};
        _ = core.device.getLimits(&limits);
        const uniform_stride = math.ceilToNextMultiple(
            @sizeOf(UBO),
            limits.limits.min_uniform_buffer_offset_alignment,
        );

        const uniform_buf = core.device.createBuffer(&.{
            .usage = .{ .uniform = true, .copy_dst = true },
            .size = lights_capacity * uniform_stride,
            .mapped_at_creation = .false,
        });

        const bind_group_layout = core.device.createBindGroupLayout(
            &gpu.BindGroupLayout.Descriptor.init(.{ .entries = &.{UBO.bind_group_layout_entry} }),
        );
        const bind_group = core.device.createBindGroup(
            &gpu.BindGroup.Descriptor.init(.{
                .layout = bind_group_layout,
                .entries = &.{
                    gpu.BindGroup.Entry.buffer(0, uniform_buf, 0, uniform_stride),
                },
            }),
        );

        const pipeline_layout = core.device.createPipelineLayout(
            &gpu.PipelineLayout.Descriptor.init(.{ .bind_group_layouts = &.{bind_group_layout} }),
        );
        const pipeline_descriptor = gpu.RenderPipeline.Descriptor{
            .layout = pipeline_layout,
            .fragment = &fragment,
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
        const pipeline = core.device.createRenderPipeline(&pipeline_descriptor);

        light.state = .{
            .pipeline = pipeline,
            .uniform_buf = uniform_buf,
            .bind_group_layout = bind_group_layout,
            .bind_group = bind_group,
            .uniform_stride = uniform_stride,
        };
    }

    pub fn deinit(light: *Mod) !void {
        light.state.bind_group_layout.release();
        light.state.bind_group.release();
        light.state.uniform_buf.release();
    }

    pub fn render(engine: *Engine.Mod, light: *Mod, camera: Camera) !void {
        engine.state.pass.setPipeline(light.state.pipeline);

        var archetypes_iter = engine.entities.query(.{ .all = &.{
            .{ .light = &.{
                .position,
                .color,
            } },
        } });

        while (archetypes_iter.next()) |archetype| {
            for (
                archetype.slice(.light, .position),
                archetype.slice(.light, .color),
                0..,
            ) |position, color, i| {
                engine.state.pass.setViewport(
                    0,
                    0,
                    @floatFromInt(core.descriptor.width),
                    @floatFromInt(core.descriptor.height),
                    0.0,
                    1.0,
                );
                engine.state.pass.setScissorRect(0, 0, core.descriptor.width, core.descriptor.height);

                const buffer_offset = @as(u32, @intCast(i)) * light.state.uniform_stride;
                core.queue.writeBuffer(
                    light.state.uniform_buf,
                    buffer_offset,
                    &[_]UBO{.{
                        .projection = camera.projection,
                        .view = camera.view,
                        .light_position = position, // TODO: x is reverted!?
                        .light_color = color,
                    }},
                );
                engine.state.pass.setBindGroup(0, light.state.bind_group, &.{buffer_offset});
                engine.state.pass.draw(6, 1, 0, 0);
            }
        }
    }
};
