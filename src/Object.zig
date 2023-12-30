const std = @import("std");
const Model = @import("Model.zig");
const Camera = @import("Camera.zig");
const mach = @import("mach");
const core = mach.core;
const gpu = mach.gpu;
const math = mach.math;
const Engine = mach.Engine;
const Vec3 = math.Vec3;
const Vec4 = math.Vec4;
const Mat4x4 = math.Mat4x4;
const vec3 = math.vec3;
const vec4 = math.vec4;
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

pub const UBO = struct {
    projection: @Vector(16, f32),
    view: @Vector(16, f32),
    model: @Vector(16, f32),

    pub const bind_group_layout_entry = gpu.BindGroupLayout.Entry.buffer(
        0,
        .{ .vertex = true, .fragment = true },
        .uniform,
        true,
        0,
    );
};

pub const local = struct {
    pub fn init(object: *Mod) !void {
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

        const objects_count = 10000; // TODO: INDEX
        const uniform_buf = core.device.createBuffer(&.{
            .usage = .{ .uniform = true, .copy_dst = true },
            .size = objects_count * uniform_stride,
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

    pub fn render(engine: *Engine.Mod, object: *Mod, camera_mod: *Camera.Mod, camera: mach.ecs.EntityID) !void {
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
                        .projection = @bitCast(camera_mod.get(camera, .projection).?.v),
                        .view = @bitCast(camera_mod.get(camera, .view).?.v),
                        .model = @bitCast(transform.mat().v),
                    }},
                );
                model.bind(engine.state.pass);
                engine.state.pass.setBindGroup(0, object.state.bind_group, &.{buffer_offset});
                model.draw(engine.state.pass);
            }
        }
    }
};

const Transform = struct {
    translation: Vec3 = vec3(0, 0, 0),
    scale: Vec3 = vec3(0.3, 0.3, 0.3),
    /// in radians
    rotation: Vec3 = vec3(0, 0, 0),

    pub fn mat(transform: Transform) Mat4x4 {
        // return Mat4x4.scale(transform.scale)
        // // .mul(&Mat4x4.rotateZ(transform.rotation.z()))
        // // .mul(&Mat4x4.rotateY(transform.rotation.y()))
        // // .mul(&Mat4x4.rotateX(transform.rotation.x()))
        //     .mul(&quaternionToMat(eulerAngleToQuaternion(transform.rotation)))
        //     .mul(&Mat4x4.translate(transform.translation));

        const c3 = @cos(transform.rotation.z());
        const s3 = @sin(transform.rotation.z());
        const c2 = @cos(transform.rotation.x());
        const s2 = @sin(transform.rotation.x());
        const c1 = @cos(transform.rotation.y());
        const s1 = @sin(transform.rotation.y());
        return mat4x4(
            &vec4(
                transform.scale.x() * (c1 * c3 + s1 * s2 * s3),
                transform.scale.x() * (c2 * s3),
                transform.scale.x() * (c1 * s2 * s3 - c3 * s1),
                0.0,
            ),
            &vec4(
                transform.scale.y() * (c3 * s1 * s2 - c1 * s3),
                transform.scale.y() * (c2 * c3),
                transform.scale.y() * (c1 * c3 * s2 + s1 * s3),
                0.0,
            ),
            &vec4(
                transform.scale.z() * (c2 * s1),
                transform.scale.z() * (-s2),
                transform.scale.z() * (c1 * c2),
                0.0,
            ),
            &vec4(
                transform.translation.x(),
                transform.translation.y(),
                transform.translation.z(),
                1.0,
            ),
        );
    }

    fn axis_angle_to_quat(axis: Vec3, angle: f32) Vec4 {
        const s = @sin(angle / 2);
        return vec4(
            axis.x() * s,
            axis.y() * s,
            axis.z() * s,
            @cos(angle / 2),
        );
    }

    fn eulerAngleToQuaternion(e: Vec3) Vec4 {
        const cx = @cos(e.x() / 2);
        const sx = @sin(e.x() / 2);
        const cy = @cos(e.y() / 2);
        const sy = @sin(e.y() / 2);
        const cz = @cos(e.z() / 2);
        const sz = @sin(e.z() / 2);
        return vec4(
            sx * cy * cz - cx * sy * sz,
            cx * sy * cz + sx * cy * sz,
            cx * cy * sz - sx * sy * cz,
            cx * cy * cz + sx * sy * sz,
        );
    }

    fn quaternionToMat(q: Vec4) Mat4x4 {
        const xx = q.x() * q.x();
        const yy = q.y() * q.y();
        const zz = q.z() * q.z();
        return mat4x4(
            &vec4(
                1 - 2 * yy - 2 * zz,
                2 * q.x() * q.y() + 2 * q.z() * q.w(),
                2 * q.x() * q.z() - 2 * q.y() * q.w(),
                0,
            ),
            &vec4(
                2 * q.x() * q.y() - 2 * q.z() * q.w(),
                1 - 2 * xx - 2 * zz,
                2 * q.y() * q.z() + 2 * q.x() * q.w(),
                0,
            ),
            &vec4(
                2 * q.x() * q.z() + 2 * q.y() * q.w(),
                2 * q.y() * q.z() - 2 * q.x() * q.w(),
                1 - 2 * xx - 2 * yy,
                0,
            ),
            &vec4(0, 0, 0, 1),
        );
    }
};
