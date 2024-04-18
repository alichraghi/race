const std = @import("std");
const mach = @import("mach");
const Game = @import("Game.zig");
const Model = @import("Model.zig");
const Camera = @import("Camera.zig");
const Light = @import("Light.zig");
const Texture = @import("Texture.zig");
const math = @import("math.zig");
const Core = mach.Core;
const gpu = mach.core.gpu;
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
const min_uniform_alignment = 256;

pub const components = .{
    .pipeline = .{ .type = u8 },
    .model = .{ .type = Model },
    .transform = .{ .type = Transform },
};

pub const local_events = .{
    .initEntity = .{ .handler = initEntity },
    .render = .{ .handler = render },
};

pipeline_keys: std.AutoArrayHashMapUnmanaged(PipelineKey, u8) = .{},
pipelines: std.AutoArrayHashMapUnmanaged(u8, Pipeline) = .{},
shader: *gpu.ShaderModule,
camera_uniform: *gpu.Buffer,
light_uniform: *gpu.Buffer,

const PipelineKey = struct {
    instance_capacity: u32,
    texture: ?Texture,
};

const Pipeline = struct {
    pipeline: *gpu.RenderPipeline,
    bind_group: *gpu.BindGroup,
    model_uniform: *gpu.Buffer,
    model_uniform_stride: u32,
};

const LightUniform = struct {
    ambient_color: Vec4,
    lights: [max_lights]Light.Uniform,
    len: u32,

    const bind_group_layout_entry = gpu.BindGroupLayout.Entry.buffer(
        1,
        .{ .vertex = true, .fragment = true },
        .uniform,
        true,
        0,
    );
};

const Uniform = struct {
    model: Mat4x4,
    normal: Mat3x3,

    const bind_group_layout_entry = gpu.BindGroupLayout.Entry.buffer(
        2,
        .{ .vertex = true, .fragment = true },
        .uniform,
        true,
        0,
    );
};

pub fn init(object: *@This()) !void {
    const shader = mach.core.device.createShaderModuleWGSL("shader.wgsl", @embedFile("shader.wgsl"));
    const camera_uniform = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(Camera.Uniform),
        .mapped_at_creation = .false,
    });
    const light_uniform = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(LightUniform),
        .mapped_at_creation = .false,
    });

    object.* = .{
        .pipeline_keys = .{},
        .pipelines = .{},
        .shader = shader,
        .camera_uniform = camera_uniform,
        .light_uniform = light_uniform,
    };
}

pub fn initEntity(
    object: *Mod,
    entity: mach.EntityID,
    instance_capacity: u32,
    texture: ?Texture,
) !void {
    const gop = try object.state().pipeline_keys.getOrPut(mach.core.allocator, .{
        .instance_capacity = instance_capacity,
        .texture = texture,
    });

    if (gop.found_existing) {
        try object.set(entity, .pipeline, gop.value_ptr.*);
        return;
    }

    const model_uniform_stride = math.ceilToNextMultiple(@sizeOf(Uniform), min_uniform_alignment);
    const model_uniform = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = instance_capacity * model_uniform_stride,
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
                gpu.BindGroup.Entry.buffer(0, object.state().camera_uniform, 0, @sizeOf(Camera.Uniform)),
                gpu.BindGroup.Entry.buffer(1, object.state().light_uniform, 0, @sizeOf(LightUniform)),
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
            .module = object.state().shader,
            .entry_point = "frag_main",
            .targets = &.{.{
                .format = mach.core.descriptor.format,
                .blend = &.{},
                .write_mask = gpu.ColorWriteMaskFlags.all,
            }},
        }),
        .vertex = gpu.VertexState.init(.{
            .module = object.state().shader,
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

    gop.value_ptr.* = @intCast(object.state().pipeline_keys.count());
    try object.state().pipelines.put(mach.core.allocator, gop.value_ptr.*, .{
        .pipeline = pipeline,
        .bind_group = bind_group,
        .model_uniform = model_uniform,
        .model_uniform_stride = model_uniform_stride,
    });
    try object.set(entity, .pipeline, gop.value_ptr.*);
}

pub fn initEntityy(
    object: *Mod,
    entity: mach.EntityID,
    instance_capacity: u32,
    texture: ?Texture,
) !void {
    const gop = try object.state().pipeline_keys.getOrPut(mach.core.allocator, .{
        .instance_capacity = instance_capacity,
        .texture = texture,
    });

    if (gop.found_existing) {
        try object.set(entity, .pipeline, gop.value_ptr.*);
        return;
    }

    const model_uniform_stride = math.ceilToNextMultiple(@sizeOf(Uniform), min_uniform_alignment);
    const model_uniform = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = instance_capacity * model_uniform_stride,
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
                gpu.BindGroup.Entry.buffer(0, object.state().camera_uniform, 0, @sizeOf(Camera.Uniform)),
                gpu.BindGroup.Entry.buffer(1, object.state().light_uniform, 0, @sizeOf(LightUniform)),
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
            .module = object.state().shader,
            .entry_point = "frag_main",
            .targets = &.{.{
                .format = mach.core.descriptor.format,
                .blend = &.{},
                .write_mask = gpu.ColorWriteMaskFlags.all,
            }},
        }),
        .vertex = gpu.VertexState.init(.{
            .module = object.state().shader,
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

    gop.value_ptr.* = @intCast(object.state().pipeline_keys.count());
    try object.state().pipelines.put(mach.core.allocator, gop.value_ptr.*, .{
        .pipeline = pipeline,
        .bind_group = bind_group,
        .model_uniform = model_uniform,
        .model_uniform_stride = model_uniform_stride,
    });
    try object.set(entity, .pipeline, gop.value_ptr.*);
}

pub fn deinit(object: *Mod) !void {
    object.state().shader.release();
    object.state().camera_uniform.release();
    object.state().light_uniform.release();
    object.state().pipeline_keys.deinit(mach.core.allocator);
    for (object.state().pipelines.values()) |pipeline| {
        pipeline.pipeline.release();
        pipeline.bind_group.release();
        pipeline.model_uniform.release();
    }
    object.state().pipelines.deinit(mach.core.allocator);
}

pub fn render(game: *Game.Mod, core: *Core.Mod, object: *Mod, camera_mod: *Camera.Mod, camera: mach.EntityID) !void {
    mach.core.queue.writeBuffer(
        object.state().camera_uniform,
        0,
        &[_]Camera.Uniform{.{
            .projection = camera_mod.get(camera, .projection).?,
            .view = camera_mod.get(camera, .view).?,
        }},
    );

    var lights = std.BoundedArray(Light.Uniform, max_lights){};
    var archetypes_iter = core.entities.query(.{ .all = &.{.{ .light = &.{ .position, .color, .radius } }} });
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
        object.state().light_uniform,
        0,
        &[_]LightUniform{.{
            .ambient_color = vec4(1, 1, 1, 0.2),
            .lights = lights.buffer,
            .len = lights.len,
        }},
    );

    archetypes_iter = core.entities.query(.{ .all = &.{.{ .object = &.{ .pipeline, .model, .transform } }} });
    while (archetypes_iter.next()) |archetype| for (
        archetype.slice(.object, .pipeline),
        archetype.slice(.object, .model),
        archetype.slice(.object, .transform),
        0..,
    ) |pipeline_key, model, transform, i| {
        const pipeline = object.state().pipelines.get(pipeline_key).?;

        game.state().pass.setPipeline(pipeline.pipeline);

        const buffer_offset = @as(u32, @intCast(i)) * pipeline.model_uniform_stride;
        mach.core.queue.writeBuffer(
            pipeline.model_uniform,
            buffer_offset,
            &[_]Uniform{.{
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
