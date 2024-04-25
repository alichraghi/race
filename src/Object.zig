const std = @import("std");
const build_options = @import("build_options");
const mach = @import("mach");
const Renderer = @import("Renderer.zig");
const Model = @import("Model.zig");
const Camera = @import("Camera.zig");
const Texture = @import("Texture.zig");
const shaders = @import("shaders.zig");
const math = @import("math.zig");
const gpu = mach.gpu;
const Vec3 = math.Vec3;
const Vec4 = math.Vec4;
const Mat3x3 = math.Mat3x3;
const Mat4x4 = math.Mat4x4;
const vec3 = math.vec3;
const vec4 = math.vec4;
const mat3x3 = math.mat3x3;
const mat4x4 = math.mat4x4;

const Object = @This();

pub const name = .object;
pub const Mod = mach.Mod(Object);

pub const components = .{
    .model = .{ .type = Model },
    .transform = .{ .type = Transform },
    .instances = .{ .type = []Transform },
};

pub const local_events = .{
    .renderGBuffer = .{ .handler = renderGBuffer },
};

pub const global_events = .{
    .framebufferResize = .{ .handler = framebufferResize },
};

pipelines: std.AutoArrayHashMapUnmanaged(Pipeline.Config, Pipeline) = .{},
gbuffers_shader: *gpu.ShaderModule = undefined,
instance_buffer: *gpu.Buffer = undefined,

pub const Transform = struct {
    translation: Vec3 = vec3(0, 0, 0),
    rotation: Vec3 = vec3(0, 0, 0),
    scale: Vec3 = vec3(1, 1, 1),
};

const Pipeline = struct {
    gbuffer_pipeline: *gpu.RenderPipeline,
    gbuffer_bind_group: *gpu.BindGroup,

    pub const Config = struct {
        material: Model.Material,
    };

    fn deinit(pipeline: *Pipeline) void {
        pipeline.gbuffer_bind_group.release();
        pipeline.gbuffer_pipeline.release();
        pipeline.* = undefined;
    }
};

const max_scene_objects = 1024;

pub fn init(object: *Object) !void {
    object.gbuffers_shader = mach.core.device.createShaderModuleWGSL("gbuffers", @embedFile("shaders/gbuffers.wgsl"));
    object.instance_buffer = mach.core.device.createBuffer(&.{
        .usage = .{ .vertex = true, .copy_dst = true },
        .size = @sizeOf(shaders.InstanceData) * max_scene_objects,
        .mapped_at_creation = .false,
    });
}

pub fn deinit(object: *Mod) !void {
    const state: *Object = object.state();

    state.bind_group_0.release();
    state.bind_group_1.release();
    state.quad_pipeline.release();
}

pub fn framebufferResize(object: *Mod, renderer: *Renderer.Mod, size: mach.core.Size) void {
    _ = size;

    const state: *Object = object.state();
    const renderer_state: *Renderer = renderer.state();

    for (state.pipelines.keys(), state.pipelines.values()) |config, *pipeline| {
        pipeline.deinit();
        pipeline.* = state.createPipeline(renderer_state, config);
    }
}

fn createPipeline(object: *Object, renderer: *Renderer, config: Pipeline.Config) Pipeline {
    // GBuffer
    const gbuffer_bind_group_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &[_]gpu.BindGroupLayout.Entry{
                .{
                    .binding = 0,
                    .visibility = .{ .vertex = true },
                    .buffer = .{
                        .type = .uniform,
                        .has_dynamic_offset = .false,
                        .min_binding_size = @sizeOf(shaders.CameraUniform),
                    },
                },
                .{
                    .binding = 1,
                    .visibility = .{ .fragment = true },
                    .texture = .{
                        .sample_type = .float,
                        .view_dimension = .dimension_2d,
                        .multisampled = .false,
                    },
                },
                .{
                    .binding = 2,
                    .visibility = .{ .fragment = true },
                    .sampler = .{ .type = .filtering },
                },
            },
        }),
    );
    defer gbuffer_bind_group_layout.release();

    const gbuffer_bind_group = mach.core.device.createBindGroup(
        &gpu.BindGroup.Descriptor.init(.{
            .layout = gbuffer_bind_group_layout,
            .entries = &.{
                .{
                    .binding = 0,
                    .buffer = renderer.camera_uniform,
                    .size = @sizeOf(shaders.CameraUniform),
                },
                .{
                    .binding = 1,
                    .texture_view = config.material.texture.view,
                    .size = 0,
                },
                .{
                    .binding = 2,
                    .sampler = config.material.texture.sampler,
                    .size = 0,
                },
            },
        }),
    );

    const gbuffer_pipeline_layout = mach.core.device.createPipelineLayout(
        &gpu.PipelineLayout.Descriptor.init(.{ .bind_group_layouts = &.{gbuffer_bind_group_layout} }),
    );
    const gbuffer_pipeline_descriptor = gpu.RenderPipeline.Descriptor{
        .layout = gbuffer_pipeline_layout,
        .fragment = &gpu.FragmentState.init(.{
            .module = object.gbuffers_shader,
            .entry_point = "frag_main",
            .targets = &.{
                .{ .format = .rgba16_float },
                .{ .format = .bgra8_unorm },
            },
        }),
        .vertex = gpu.VertexState.init(.{
            .module = object.gbuffers_shader,
            .entry_point = "vertex_main",
            .buffers = &.{ shaders.Vertex.layout, shaders.InstanceData.layout },
        }),
        .depth_stencil = &.{
            .format = .depth24_plus,
            .depth_write_enabled = .true,
            .depth_compare = .less,
        },
    };
    const gbuffer_pipeline = mach.core.device.createRenderPipeline(&gbuffer_pipeline_descriptor);

    return .{ .gbuffer_pipeline = gbuffer_pipeline, .gbuffer_bind_group = gbuffer_bind_group };
}

fn getPipeline(object: *Object, renderer: *Renderer, config: Pipeline.Config) !*Pipeline {
    const gop = try object.pipelines.getOrPut(mach.core.allocator, config);
    if (gop.found_existing) return gop.value_ptr;
    gop.value_ptr.* = createPipeline(object, renderer, config);
    return gop.value_ptr;
}

pub fn renderGBuffer(object: *Mod, renderer: *Renderer.Mod) !void {
    const state: *Object = object.state();
    const renderer_state: *Renderer = renderer.state();

    // Instance Data
    var buffer_offset: u32 = 0;
    var object_iter = object.entities.query(.{ .all = &.{.{ .object = &.{.model} }} });
    while (object_iter.next()) |archetype| for (
        archetype.slice(.entity, .id),
        archetype.slice(.object, .model),
    ) |id, model| {
        const transform = object.get(id, .transform);
        const instances = object.get(id, .instances);

        const transforms = if (transform) |single| &.{single} else instances.?;
        std.debug.assert(transforms.len > 0);

        const start_offset = buffer_offset;
        for (transforms) |instance| {
            // writeBuffer is just a @memcpy
            mach.core.queue.writeBuffer(
                state.instance_buffer,
                buffer_offset,
                &[_]shaders.InstanceData{.{
                    .model = math.transform(instance.translation, instance.rotation, instance.scale),
                    .model_normal = math.transformNormal(instance.rotation, instance.scale),
                }},
            );
            buffer_offset += @sizeOf(shaders.InstanceData);
        }

        renderer_state.gbuffer_pass.setVertexBuffer(1, state.instance_buffer, start_offset, transforms.len * @sizeOf(shaders.InstanceData));

        for (model.meshes) |mesh| {
            const pipeline = try state.getPipeline(renderer_state, .{ .material = model.materials[mesh.material] });
            renderer_state.gbuffer_pass.setPipeline(pipeline.gbuffer_pipeline);
            renderer_state.gbuffer_pass.setBindGroup(0, pipeline.gbuffer_bind_group, null);
            renderer_state.gbuffer_pass.setVertexBuffer(0, mesh.vertex_buf, 0, mesh.vertex_count * @sizeOf(shaders.Vertex));
            if (mesh.index_buf) |index_buf| {
                renderer_state.gbuffer_pass.setIndexBuffer(index_buf, .uint32, 0, mesh.index_count * @sizeOf(u32));
            }

            if (mesh.index_buf) |_| {
                renderer_state.gbuffer_pass.drawIndexed(mesh.index_count, @intCast(transforms.len), 0, 0, 0);
            } else {
                renderer_state.gbuffer_pass.draw(mesh.vertex_count, @intCast(transforms.len), 0, 0);
            }
        }
    };
}
