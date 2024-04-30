const std = @import("std");
const build_options = @import("build_options");
const mach = @import("mach");
const Game = @import("Game.zig");
const Model = @import("Model.zig");
const Camera = @import("Camera.zig");
const Texture = @import("Texture.zig");
const shaders = @import("shaders.zig");
const math = @import("math.zig");
const gpu = mach.gpu;
const Vec3 = math.Vec3;
const Mat3x3 = math.Mat3x3;
const Mat4x4 = math.Mat4x4;
const vec3 = math.vec3;
const vec4 = math.vec4;
const mat3x3 = math.mat3x3;

const Object = @This();

pub const name = .object;
pub const Mod = mach.Mod(Object);

pub const components = .{
    .model = .{ .type = Model },
    .transform = .{ .type = Transform },
    .instances = .{ .type = []Transform },
};

pub const local_events = .{
    .render = .{ .handler = render },
};

pipelines: std.ArrayHashMapUnmanaged(Pipeline.Config, Pipeline, Pipeline.Config.ArrayHashContext, false) = .{},
shader: *gpu.ShaderModule,
camera_uniform: *gpu.Buffer,
light_list_uniform: *gpu.Buffer,
instance_buffer: *gpu.Buffer,
material_config_uniform: *gpu.Buffer,

pub const Transform = struct {
    translation: Vec3 = vec3(0, 0, 0),
    rotation: Vec3 = vec3(0, 0, 0),
    scale: Vec3 = vec3(1, 1, 1),
};

const Pipeline = struct {
    pipeline: *gpu.RenderPipeline,
    bind_group: *gpu.BindGroup,

    pub const Config = struct {
        material: Model.Material,

        pub const ArrayHashContext = struct {
            pub fn eql(ctx: ArrayHashContext, a: Config, b: Config, _: usize) bool {
                _ = ctx;
                return a.material.id == b.material.id;
            }

            pub fn hash(ctx: ArrayHashContext, a: Config) u32 {
                _ = ctx;
                return a.material.id;
            }
        };
    };
};

const max_scene_objects = 1024;
const max_materials = 1024;

pub fn init(object: *Object) !void {
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
    const instance_buffer = mach.core.device.createBuffer(&.{
        .usage = .{ .vertex = true, .copy_dst = true },
        .size = @sizeOf(shaders.InstanceData) * max_scene_objects, // TODO: enough?
        .mapped_at_creation = .false,
    });
    const material_config_uniform = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(shaders.MaterialConfig) * max_materials,
        .mapped_at_creation = .false,
    });

    object.* = .{
        .shader = shader,
        .camera_uniform = camera_uniform,
        .light_list_uniform = light_list_uniform,
        .instance_buffer = instance_buffer,
        .material_config_uniform = material_config_uniform,
    };
}

pub fn getPipeline(object: *Object, config: Pipeline.Config) !*Pipeline {
    const gop = try object.pipelines.getOrPut(mach.core.allocator, config);
    if (gop.found_existing) return gop.value_ptr;

    const material = config.material;
    //  try Texture.initFromFile("assets/missing.png");

    const bind_group_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &.{
                gpu.BindGroupLayout.Entry.buffer(0, .{ .vertex = true, .fragment = true }, .uniform, false, 0),
                gpu.BindGroupLayout.Entry.buffer(1, .{ .vertex = true, .fragment = true }, .uniform, false, 0),
                gpu.BindGroupLayout.Entry.buffer(2, .{ .fragment = true }, .uniform, true, 0),
                gpu.BindGroupLayout.Entry.sampler(3, .{ .fragment = true }, .filtering),
                gpu.BindGroupLayout.Entry.texture(4, .{ .fragment = true }, .float, .dimension_2d, false),
            },
        }),
    );
    defer bind_group_layout.release();

    const bind_group = mach.core.device.createBindGroup(
        &gpu.BindGroup.Descriptor.init(.{
            .layout = bind_group_layout,
            .entries = &.{
                gpu.BindGroup.Entry.buffer(0, object.camera_uniform, 0, @sizeOf(shaders.CameraUniform)),
                gpu.BindGroup.Entry.buffer(1, object.light_list_uniform, 0, @sizeOf(shaders.LightListUniform)),
                gpu.BindGroup.Entry.buffer(2, object.material_config_uniform, 0, @sizeOf(shaders.MaterialConfig)),
                gpu.BindGroup.Entry.sampler(3, material.texture.sampler),
                gpu.BindGroup.Entry.textureView(4, material.texture.view),
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
            .buffers = &.{ shaders.Vertex.layout, shaders.InstanceData.layout },
        }),
        .depth_stencil = &.{
            .format = .depth24_plus,
            .depth_write_enabled = .true,
            .depth_compare = .less,
        },
    };
    const pipeline = mach.core.device.createRenderPipeline(&pipeline_descriptor);

    gop.value_ptr.* = .{ .pipeline = pipeline, .bind_group = bind_group };
    return gop.value_ptr;
}

pub fn deinit(object: *Mod) !void {
    const state = object.state();

    state.shader.release();
    state.camera_uniform.release();
    state.light_uniform.release();
    for (state.pipelines.values()) |pipeline| {
        pipeline.pipeline.release();
        pipeline.bind_group.release();
    }
    state.pipelines.deinit(mach.core.allocator);
}

pub fn render(object: *Mod, game: *Game.Mod, camera: Camera) !void {
    const state: *Object = object.state();
    const game_state: *Game = game.state();

    // Camera Uniform
    mach.core.queue.writeBuffer(
        state.camera_uniform,
        0,
        &[_]shaders.CameraUniform{.{
            .projection = camera.projection,
            .view = camera.view,
        }},
    );

    // Light Uniform
    var lights = std.BoundedArray(shaders.LightUniform, shaders.max_lights){};
    var lights_iter = object.entities.query(.{ .all = &.{.{ .light = &.{ .position, .color, .radius } }} });
    while (lights_iter.next()) |archetype| for (
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

    // Instance Data
    var instance_offset: u32 = 0;
    var material_config_offset: u32 = 0;
    var object_iter = object.entities.query(.{ .all = &.{.{ .object = &.{.model} }} });
    while (object_iter.next()) |archetype| for (
        archetype.slice(.entity, .id),
        archetype.slice(.object, .model),
    ) |id, model| {
        const transform = object.get(id, .transform);
        const instances = object.get(id, .instances);

        const transforms = if (transform) |single| &.{single} else instances.?;
        std.debug.assert(transforms.len > 0);

        const instance_start_offset = instance_offset;
        for (transforms) |instance| {
            // writeBuffer is just a @memcpy
            mach.core.queue.writeBuffer(
                state.instance_buffer,
                instance_offset,
                &[_]shaders.InstanceData{.{
                    .transform = math.transform(instance.translation, instance.rotation, instance.scale),
                    .normal = math.transformNormal(instance.rotation, instance.scale),
                }},
            );
            instance_offset += @sizeOf(shaders.InstanceData);
        }

        for (model.meshes) |mesh| {
            const material = model.materials[mesh.material];
            const pipeline = try state.getPipeline(.{ .material = material });

            mach.core.queue.writeBuffer(
                state.material_config_uniform,
                material_config_offset,
                &[_]shaders.MaterialConfig{.{
                    .metallic = material.metallic,
                    .roughness = material.roughness,
                }},
            );

            game_state.pass.setPipeline(pipeline.pipeline);
            game_state.pass.setBindGroup(0, pipeline.bind_group, &.{material_config_offset});
            game_state.pass.setVertexBuffer(0, mesh.vertex_buf, 0, mesh.vertex_count * @sizeOf(shaders.Vertex));
            game_state.pass.setVertexBuffer(1, state.instance_buffer, instance_start_offset, transforms.len * @sizeOf(shaders.InstanceData));
            if (mesh.index_buf) |index_buf| {
                game_state.pass.setIndexBuffer(index_buf, .uint32, 0, mesh.index_count * @sizeOf(u32));
                game_state.pass.drawIndexed(mesh.index_count, @intCast(transforms.len), 0, 0, 0);
            } else {
                game_state.pass.draw(mesh.vertex_count, @intCast(transforms.len), 0, 0);
            }

            material_config_offset += @sizeOf(shaders.MaterialConfig);
        }
    };
}
