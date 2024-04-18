const std = @import("std");
const build_options = @import("build_options");
const mach = @import("mach");
const Game = @import("Game.zig");
const Model = @import("Model.zig");
const Camera = @import("Camera.zig");
const Texture = @import("Texture.zig");
const shaders = @import("shaders.zig");
const math = @import("math.zig");
const gpu = mach.core.gpu;
const Vec3 = math.Vec3;
const Mat3x3 = math.Mat3x3;
const Mat4x4 = math.Mat4x4;
const vec3 = math.vec3;
const vec4 = math.vec4;
const mat3x3 = math.mat3x3;

pub const name = .object;
pub const Mod = mach.Mod(@This());

pub const components = .{
    .pipeline_config = .{ .type = PipelineConfig },
    .model = .{ .type = Model },
    .transform = .{ .type = Transform },
};

pub const local_events = .{
    .render = .{ .handler = render },
};

pipelines: std.AutoArrayHashMapUnmanaged(PipelineConfig, Pipeline) = .{},
shader: *gpu.ShaderModule,
camera_uniform: *gpu.Buffer,
light_list_uniform: *gpu.Buffer,

const PipelineConfig = struct {
    instance_capacity: u32,
    texture: ?Texture = null,
};

const Pipeline = struct {
    pipeline: *gpu.RenderPipeline,
    bind_group: *gpu.BindGroup,
    model_uniform: *gpu.Buffer,
    model_uniform_stride: u32,
};

pub fn init(object: *@This()) !void {
    const shader = mach.core.device.createShaderModuleWGSL("object", @embedFile("shaders/object.wgsl"));
    const camera_uniform = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(shaders.CameraUniform),
        .mapped_at_creation = .false,
    });
    const light_list_uniform = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(shaders.LightListUniform),
        .mapped_at_creation = .false,
    });

    object.* = .{
        .shader = shader,
        .camera_uniform = camera_uniform,
        .light_list_uniform = light_list_uniform,
    };
}

pub fn getPipeline(object: *@This(), config: PipelineConfig) !Pipeline {
    const gop = try object.pipelines.getOrPut(mach.core.allocator, config);
    if (gop.found_existing) return gop.value_ptr.*;

    var limits = gpu.SupportedLimits{
        // TODO(sysgpu)
        .limits = .{
            .min_uniform_buffer_offset_alignment = 256,
        },
    };
    if (!build_options.use_sysgpu) {
        _ = mach.core.device.getLimits(&limits);
    }

    const model_uniform_stride = math.ceilToNextMultiple(@sizeOf(shaders.ObjectUniform), 256);
    const model_uniform = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = config.instance_capacity * model_uniform_stride,
        .mapped_at_creation = .false,
    });

    const marble_texture = try Texture.initFromFile("assets/missing.png");

    const bind_group_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{ .entries = &.{
            gpu.BindGroupLayout.Entry.buffer(0, .{ .vertex = true, .fragment = true }, .uniform, false, 0),
            gpu.BindGroupLayout.Entry.buffer(1, .{ .vertex = true, .fragment = true }, .uniform, false, 0),
            gpu.BindGroupLayout.Entry.buffer(2, .{ .vertex = true }, .uniform, true, 0),
            gpu.BindGroupLayout.Entry.sampler(3, .{ .fragment = true }, .filtering),
            gpu.BindGroupLayout.Entry.texture(4, .{ .fragment = true }, .float, .dimension_2d, false),
        } }),
    );
    defer bind_group_layout.release();

    const bind_group = mach.core.device.createBindGroup(
        &gpu.BindGroup.Descriptor.init(.{
            .layout = bind_group_layout,
            .entries = &.{
                // TODO(sysgpu)
                if (build_options.use_sysgpu)
                    gpu.BindGroup.Entry.buffer(0, object.camera_uniform, 0, @sizeOf(shaders.CameraUniform), 0)
                else
                    gpu.BindGroup.Entry.buffer(0, object.camera_uniform, 0, @sizeOf(shaders.CameraUniform)),
                if (build_options.use_sysgpu)
                    gpu.BindGroup.Entry.buffer(1, object.light_list_uniform, 0, @sizeOf(shaders.LightListUniform), 0)
                else
                    gpu.BindGroup.Entry.buffer(1, object.light_list_uniform, 0, @sizeOf(shaders.LightListUniform)),
                if (build_options.use_sysgpu)
                    gpu.BindGroup.Entry.buffer(2, model_uniform, 0, model_uniform_stride, 0)
                else
                    gpu.BindGroup.Entry.buffer(2, model_uniform, 0, model_uniform_stride),

                gpu.BindGroup.Entry.sampler(3, marble_texture.sampler),
                gpu.BindGroup.Entry.textureView(4, marble_texture.view),
            },
        }),
    );

    const pipeline_layout = mach.core.device.createPipelineLayout(
        &gpu.PipelineLayout.Descriptor.init(.{ .bind_group_layouts = &.{bind_group_layout} }),
    );
    const pipeline_descriptor = gpu.RenderPipeline.Descriptor{
        .layout = pipeline_layout,
        .fragment = &gpu.FragmentState.init(.{
            .module = object.shader,
            .entry_point = "frag_main",
            .targets = &.{.{
                .format = mach.core.descriptor.format,
                .blend = &.{},
                .write_mask = gpu.ColorWriteMaskFlags.all,
            }},
        }),
        .vertex = gpu.VertexState.init(.{
            .module = object.shader,
            .entry_point = "vertex_main",
            .buffers = &.{Model.Vertex.layout},
        }),
        .depth_stencil = &.{
            .format = .depth24_plus,
            .depth_write_enabled = .true,
            .depth_compare = .less,
        },
    };
    const pipeline = mach.core.device.createRenderPipeline(&pipeline_descriptor);

    gop.value_ptr.* = .{
        .pipeline = pipeline,
        .bind_group = bind_group,
        .model_uniform = model_uniform,
        .model_uniform_stride = model_uniform_stride,
    };

    return gop.value_ptr.*;
}

pub fn deinit(object: *Mod) !void {
    const state = object.state();

    state.shader.release();
    state.camera_uniform.release();
    state.light_uniform.release();
    state.pipeline_keys.deinit(mach.core.allocator);
    for (state.pipelines.values()) |pipeline| {
        pipeline.pipeline.release();
        pipeline.bind_group.release();
        pipeline.model_uniform.release();
    }
    state.pipelines.deinit(mach.core.allocator);
}

// TODO(WORKAROUND): Camera shouldn't be a pointer
pub fn render(object: *Mod, game: *Game.Mod, camera: *const Camera) !void {
    const state = object.state();

    mach.core.queue.writeBuffer(
        state.camera_uniform,
        0,
        &[_]shaders.CameraUniform{.{
            .projection = camera.projection,
            .view = camera.view,
        }},
    );

    var lights = std.BoundedArray(shaders.LightUniform, shaders.max_lights){};
    var archetypes_iter = object.entities.query(.{ .all = &.{.{ .light = &.{ .position, .color, .radius } }} });
    while (archetypes_iter.next()) |archetype| for (
        archetype.slice(.light, .position),
        archetype.slice(.light, .color),
        archetype.slice(.light, .radius),
    ) |position, color, radius| {
        try lights.append(.{
            .position = position, // TODO: x is reverse?!
            .color = color,
            .radius = radius,
        });
    };

    mach.core.queue.writeBuffer(
        state.light_list_uniform,
        0,
        &[_]shaders.LightListUniform{.{
            .ambient_color = vec4(1, 1, 1, 0.2),
            .lights = lights.buffer,
            .len = lights.len,
        }},
    );

    archetypes_iter = object.entities.query(.{ .all = &.{.{ .object = &.{ .pipeline_config, .model, .transform } }} });
    while (archetypes_iter.next()) |archetype| for (
        archetype.slice(.object, .pipeline_config),
        archetype.slice(.object, .model),
        archetype.slice(.object, .transform),
        0..,
    ) |pipeline_config, model, transform, i| {
        const pipeline = try state.getPipeline(pipeline_config);

        game.state().pass.setPipeline(pipeline.pipeline);

        const buffer_offset = @as(u32, @intCast(i)) * pipeline.model_uniform_stride;
        mach.core.queue.writeBuffer(
            pipeline.model_uniform,
            buffer_offset,
            &[_]shaders.ObjectUniform{.{
                .model = transform.mat(),
                .normal = transform.normalMat(),
            }},
        );
        game.state().pass.setBindGroup(0, pipeline.bind_group, &.{buffer_offset});

        model.bind(game.state().pass);
        model.draw(game.state().pass);
    };
}

pub const Transform = struct {
    translation: Vec3 = vec3(0, 0, 0),
    scale: Vec3 = vec3(1, 1, 1),
    /// in radians
    rotation: Vec3 = vec3(0, 0, 0),

    pub fn mat(transform: Transform) Mat4x4 {
        const translation = Mat4x4.translate(transform.translation);
        const scale = Mat4x4.scale(transform.scale);
        const rotation = Mat4x4.rotateZ(transform.rotation.z())
            .mul(&Mat4x4.rotateY(transform.rotation.y()))
            .mul(&Mat4x4.rotateX(transform.rotation.x()));
        return translation.mul(&rotation).mul(&scale);
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
                inv_scale.y() * (c3 * s1 * s2 + c1 * s3),
                inv_scale.y() * (c2 * c3),
                inv_scale.y() * (c1 * c3 * s2 - s1 * s3),
            ),
            &vec3(
                inv_scale.z() * (c2 * s1),
                inv_scale.z() * (-s2),
                inv_scale.z() * (c1 * c2),
            ),
        );
    }
};
