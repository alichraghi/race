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

pub const name = .object;
pub const Mod = mach.Mod(@This());

const max_lights = 10;

pub const components = struct {
    pub const model = Model;
    pub const transform = Transform;
};

pipeline: *gpu.RenderPipeline,
bind_group_layout: *gpu.BindGroupLayout,
bind_group: *gpu.BindGroup,

camera_uniform_buf: *gpu.Buffer,
light_uniform_buf: *gpu.Buffer,
model_uniform_buf: *gpu.Buffer,
model_uniform_stride: u32,

pub const CameraUniform = struct {
    projection: Mat4x4,
    view: Mat4x4,

    pub const bind_group_layout_entry = gpu.BindGroupLayout.Entry.buffer(
        0,
        .{ .vertex = true, .fragment = true },
        .uniform,
        true,
        0,
    );
};

pub const LightObject = struct {
    position: Vec3,
    color: Vec4,
};

pub const LightUniform = struct {
    ambient_color: Vec4,
    lights: [max_lights]LightObject,
    len: u32,

    pub const bind_group_layout_entry = gpu.BindGroupLayout.Entry.buffer(
        1,
        .{ .vertex = true, .fragment = true },
        .uniform,
        true,
        0,
    );
};

pub const ModelUniform = struct {
    model: Mat4x4,
    normal: Mat3x3,

    pub const bind_group_layout_entry = gpu.BindGroupLayout.Entry.buffer(
        2,
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

        const camera_uniform_buf = core.device.createBuffer(&.{
            .usage = .{ .uniform = true, .copy_dst = true },
            .size = @sizeOf(CameraUniform),
            .mapped_at_creation = .false,
        });

        const light_uniform_buf = core.device.createBuffer(&.{
            .usage = .{ .uniform = true, .copy_dst = true },
            .size = @sizeOf(LightUniform),
            .mapped_at_creation = .false,
        });

        const model_uniform_stride = math.ceilToNextMultiple(
            @sizeOf(ModelUniform),
            limits.limits.min_uniform_buffer_offset_alignment,
        );
        const model_uniform_buf = core.device.createBuffer(&.{
            .usage = .{ .uniform = true, .copy_dst = true },
            .size = objects_capacity * model_uniform_stride,
            .mapped_at_creation = .false,
        });

        const bind_group_layout = core.device.createBindGroupLayout(
            &gpu.BindGroupLayout.Descriptor.init(.{ .entries = &.{
                CameraUniform.bind_group_layout_entry,
                LightUniform.bind_group_layout_entry,
                ModelUniform.bind_group_layout_entry,
            } }),
        );
        const bind_group = core.device.createBindGroup(
            &gpu.BindGroup.Descriptor.init(.{
                .layout = bind_group_layout,
                .entries = &.{
                    gpu.BindGroup.Entry.buffer(0, camera_uniform_buf, 0, @sizeOf(CameraUniform)),
                    gpu.BindGroup.Entry.buffer(1, light_uniform_buf, 0, @sizeOf(LightUniform)),
                    gpu.BindGroup.Entry.buffer(2, model_uniform_buf, 0, model_uniform_stride),
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
            .camera_uniform_buf = camera_uniform_buf,
            .light_uniform_buf = light_uniform_buf,
            .model_uniform_buf = model_uniform_buf,
            .bind_group_layout = bind_group_layout,
            .bind_group = bind_group,
            .model_uniform_stride = model_uniform_stride,
        };
    }

    pub fn deinit(object: *Mod) !void {
        object.state.bind_group_layout.release();
        object.state.bind_group.release();
        object.state.camera_uniform_buf.release();
        object.state.light_uniform_buf.release();
        object.state.model_uniform_buf.release();
    }

    pub fn render(engine: *Engine.Mod, object: *Mod, camera_mod: *Camera.Mod, camera: mach.ecs.EntityID) !void {
        engine.state.pass.setPipeline(object.state.pipeline);

        core.queue.writeBuffer(
            object.state.camera_uniform_buf,
            0,
            &[_]CameraUniform{.{
                .projection = camera_mod.get(camera, .projection).?,
                .view = camera_mod.get(camera, .view).?,
            }},
        );

        var lights = std.BoundedArray(LightObject, max_lights){};

        var archetypes_iter = engine.entities.query(.{ .all = &.{.{ .light = &.{ .position, .color } }} });
        while (archetypes_iter.next()) |archetype| for (
            archetype.slice(.light, .position),
            archetype.slice(.light, .color),
        ) |position, color| {
            try lights.append(.{
                .position = position, // TODO: x is reverse?!
                .color = color,
            });
        };

        core.queue.writeBuffer(
            object.state.light_uniform_buf,
            0,
            &[_]LightUniform{.{
                .ambient_color = vec4(1, 1, 1, 0.2),
                .lights = lights.buffer,
                .len = lights.len,
            }},
        );

        archetypes_iter = engine.entities.query(.{ .all = &.{.{ .object = &.{ .model, .transform } }} });
        while (archetypes_iter.next()) |archetype| for (
            archetype.slice(.object, .model),
            archetype.slice(.object, .transform),
            0..,
        ) |model, transform, i| {
            const buffer_offset = @as(u32, @intCast(i)) * object.state.model_uniform_stride;
            core.queue.writeBuffer(
                object.state.model_uniform_buf,
                buffer_offset,
                &[_]ModelUniform{.{
                    .model = transform.mat(),
                    .normal = transform.normalMat(),
                }},
            );
            engine.state.pass.setBindGroup(0, object.state.bind_group, &.{ 0, 0, buffer_offset });

            model.bind(engine.state.pass);
            model.draw(engine.state.pass);
        };
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
