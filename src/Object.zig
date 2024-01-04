const std = @import("std");
const mach = @import("mach");
const core = mach.core;
const Engine = mach.Engine;
const gpu = core.gpu;
const Model = @import("Model.zig");
const Camera = @import("Camera.zig");
const math = mach.math;
const Vec3 = math.Vec3;
const Vec4 = math.Vec4;
const Mat3x3 = math.Mat3x3;
const Mat4x4 = math.Mat4x4;
const vec3 = math.vec3;
const vec4 = math.vec4;
const mat3x3 = math.mat3x3;
const mat4x4 = math.mat4x4;

pub const name = .object;
pub const Mod = mach.Mod(@This());

pub const components = struct {
    pub const model = Model;
    pub const transform = Transform;
    pub const color = Vec3;
};

pipeline: *gpu.RenderPipeline,
uniform_buf: *gpu.Buffer,
bind_group_layout: *gpu.BindGroupLayout,
bind_group: *gpu.BindGroup,
uniform_stride: u32,

fn ceilToNextMultiple(value: u32, step: u32) u32 {
    const divide_and_ceil = value / step + @as(u32, if (value % step == 0) 0 else 1);
    return step * divide_and_ceil;
}

pub const UBO = extern struct {
    projection: Mat4x4,
    view: Mat4x4,
    model: Mat4x4,
    normal: Mat3x3,
    ambient_light_color: Vec4,
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
    pub fn init(object: *Mod, objects_capacity: u32) !void {
        const shader_module = core.device.createShaderModuleWGSL("shader.wgsl", @embedFile("shader.wgsl"));
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
        const uniform_stride = ceilToNextMultiple(
            @sizeOf(UBO),
            limits.limits.min_uniform_buffer_offset_alignment,
        );

        const uniform_buf = core.device.createBuffer(&.{
            .usage = .{ .uniform = true, .copy_dst = true },
            .size = objects_capacity * uniform_stride,
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
                .buffers = &.{Model.Vertex.layout},
            }),
            .primitive = .{},
            .depth_stencil = &.{
                .format = .depth24_plus,
                .depth_write_enabled = .true,
                .depth_compare = .less,
            },
        };
        const pipeline = core.device.createRenderPipeline(&pipeline_descriptor);

        object.state = .{
            .pipeline = pipeline,
            .uniform_buf = uniform_buf,
            .bind_group_layout = bind_group_layout,
            .bind_group = bind_group,
            .uniform_stride = uniform_stride,
        };
    }

    pub fn deinit(object: *Mod) !void {
        object.state.bind_group_layout.release();
        object.state.bind_group.release();
        object.state.uniform_buf.release();
    }

    pub fn render(engine: *Engine.Mod, object: *Mod, camera: Camera) !void {
        engine.state.pass.setPipeline(object.state.pipeline);

        var archetypes_iter = engine.entities.query(.{ .all = &.{
            .{ .object = &.{
                .model,
                .transform,
                .color,
            } },
        } });

        while (archetypes_iter.next()) |archetype| {
            for (
                archetype.slice(.object, .model),
                archetype.slice(.object, .transform),
                0..,
            ) |model, transform, i| {
                engine.state.pass.setViewport(
                    0,
                    0,
                    @floatFromInt(core.descriptor.width),
                    @floatFromInt(core.descriptor.height),
                    0.0,
                    1.0,
                );
                engine.state.pass.setScissorRect(0, 0, core.descriptor.width, core.descriptor.height);

                const buffer_offset = @as(u32, @intCast(i)) * object.state.uniform_stride;
                core.queue.writeBuffer(
                    object.state.uniform_buf,
                    buffer_offset,
                    &[_]UBO{.{
                        .projection = camera.projection,
                        .view = camera.view,
                        .model = transform.mat(),
                        .normal = transform.normalMat(),
                        .ambient_light_color = vec4(1, 1, 1, 0.2),
                        .light_position = vec3(0, 1, -1), // TODO: x is reverted!?
                        .light_color = vec4(1, 1, 1, 1),
                    }},
                );
                model.bind(engine.state.pass);
                engine.state.pass.setBindGroup(0, object.state.bind_group, &.{buffer_offset});
                model.draw(engine.state.pass);
            }
        }
    }
};

pub const Transform = struct {
    translation: Vec3 = vec3(0, 0, 0),
    scale: Vec3 = vec3(1, 1, 1),
    /// in radians
    rotation: Vec3 = vec3(0, 0, 0),

    pub fn mat(transform: Transform) Mat4x4 {
        const translation = Mat4x4.translate(transform.translation);
        const scale = Mat4x4.scale(transform.scale);
        const rotation = Mat4x4.rotateX(transform.rotation.x())
            .mul(&Mat4x4.rotateY(transform.rotation.y()))
            .mul(&Mat4x4.rotateZ(transform.rotation.z()));
        return scale.mul(&rotation.mul(&translation));
    }

    pub fn normalMat(transform: Transform) Mat3x3 {
        const c3 = @cos(transform.rotation.z());
        const s3 = @sin(transform.rotation.z());
        const c2 = @cos(transform.rotation.x());
        const s2 = @sin(transform.rotation.x());
        const c1 = @cos(transform.rotation.y());
        const s1 = @sin(transform.rotation.y());
        const inv_scale = vec3(1, 1, 1).div(&transform.scale);

        return mat3x3(
            &vec3(
                inv_scale.x() * (c1 * c3 + s1 * s2 * s3),
                inv_scale.x() * (c2 * s3),
                inv_scale.x() * (c1 * s2 * s3 - c3 * s1),
            ),
            &vec3(
                inv_scale.y() * (c3 * s1 * s2 - c1 * s3),
                inv_scale.y() * (c2 * c3),
                inv_scale.y() * (c1 * c3 * s2 + s1 * s3),
            ),
            &vec3(
                inv_scale.z() * (c2 * s1),
                inv_scale.z() * (-s2),
                inv_scale.z() * (c1 * c2),
            ),
        );
    }
};
