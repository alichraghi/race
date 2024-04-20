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
const Transform = math.Transform;
const vec3 = math.vec3;
const vec4 = math.vec4;
const mat3x3 = math.mat3x3;

const Object = @This();

pub const name = .object;
pub const Mod = mach.Mod(Object);

pub const components = .{
    .texture = .{ .type = ?Texture },
    .model = .{ .type = Model },
    .transforms = .{ .type = []Transform },
};

pub const local_events = .{
    .render = .{ .handler = render },
};

pipelines: std.AutoArrayHashMapUnmanaged(PipelineConfig, Pipeline) = .{},
shader: *gpu.ShaderModule,
camera_uniform: *gpu.Buffer,
light_list_uniform: *gpu.Buffer,
instance_buffer: *gpu.Buffer,

pub const PipelineConfig = struct {
    texture: ?Texture,
};

const Pipeline = struct {
    pipeline: *gpu.RenderPipeline,
    bind_group: *gpu.BindGroup,
};

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
        .size = @sizeOf(shaders.InstanceData) * 1024, // TODO: enough?
        .mapped_at_creation = .false,
    });

    object.* = .{
        .shader = shader,
        .camera_uniform = camera_uniform,
        .light_list_uniform = light_list_uniform,
        .instance_buffer = instance_buffer,
    };
}

pub fn getPipeline(object: *Object, config: PipelineConfig) !*Pipeline {
    const gop = try object.pipelines.getOrPut(mach.core.allocator, config);
    if (gop.found_existing) return gop.value_ptr;

    const marble_texture = try Texture.initFromFile("assets/missing.png");

    const bind_group_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &.{
                gpu.BindGroupLayout.Entry.buffer(0, .{ .vertex = true, .fragment = true }, .uniform, false, 0),
                gpu.BindGroupLayout.Entry.buffer(1, .{ .vertex = true, .fragment = true }, .uniform, false, 0),
                gpu.BindGroupLayout.Entry.sampler(2, .{ .fragment = true }, .filtering),
                gpu.BindGroupLayout.Entry.texture(3, .{ .fragment = true }, .float, .dimension_2d, false),
            },
        }),
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
                gpu.BindGroup.Entry.sampler(2, marble_texture.sampler),
                gpu.BindGroup.Entry.textureView(3, marble_texture.view),
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
            .buffers = &.{ Model.Vertex.layout, shaders.InstanceData.layout },
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

// TODO(WORKAROUND): Camera shouldn't be a pointer
pub fn render(object: *Mod, game: *Game.Mod, camera: *const Camera) !void {
    const state: *Object = object.state();
    const game_state: *Game = game.state();

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

    var buffer_offset: u32 = 0;
    archetypes_iter = object.entities.query(.{ .all = &.{.{ .object = &.{ .texture, .model, .transforms } }} });
    while (archetypes_iter.next()) |archetype| for (
        archetype.slice(.object, .texture),
        archetype.slice(.object, .model),
        archetype.slice(.object, .transforms),
    ) |texture, model, transforms| {
        const pipeline = try state.getPipeline(.{ .texture = texture });

        const start_offset = buffer_offset;
        std.debug.assert(transforms.len > 0);

        for (transforms) |transform| {
            // writeBuffer is just a @memcpy
            mach.core.queue.writeBuffer(
                state.instance_buffer,
                buffer_offset,
                &[_]shaders.InstanceData{.{
                    .transform = transform.mat(),
                    .normal = transform.normalMat(),
                }},
            );
            buffer_offset += @sizeOf(shaders.InstanceData);
        }

        game_state.pass.setPipeline(pipeline.pipeline);
        game_state.pass.setBindGroup(0, pipeline.bind_group, &.{});
        game_state.pass.setVertexBuffer(0, model.vertex_buf, 0, model.vertex_count * @sizeOf(Model.Vertex));
        game_state.pass.setVertexBuffer(1, state.instance_buffer, start_offset, transforms.len * @sizeOf(shaders.InstanceData));
        if (model.index_buf) |index_buf| {
            game_state.pass.setIndexBuffer(index_buf, .uint32, 0, model.index_count * @sizeOf(u32));
        }

        if (model.index_buf) |_| {
            game_state.pass.drawIndexed(model.index_count, @intCast(transforms.len), 0, 0, 0);
        } else {
            game_state.pass.draw(model.vertex_count, @intCast(transforms.len), 0, 0);
        }
    };
}
