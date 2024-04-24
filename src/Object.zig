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
    .texture = .{ .type = ?Texture },
    .model = .{ .type = Model },
    .transform = .{ .type = Transform },
    .instances = .{ .type = []Transform },
};

pub const local_events = .{
    .renderGBuffer = .{ .handler = renderGBuffer },
    .render = .{ .handler = render },
};

pub const global_events = .{
    .framebufferResize = .{ .handler = framebufferResize },
};

pipelines: std.AutoArrayHashMapUnmanaged(Pipeline.Config, Pipeline) = .{},
deferred_rendering_shader: *gpu.ShaderModule = undefined,
write_gbuffer_shader: *gpu.ShaderModule = undefined,
camera_uniform: *gpu.Buffer = undefined,
lights_buffer: *gpu.Buffer = undefined,
instance_buffer: *gpu.Buffer = undefined,

pub const Transform = struct {
    translation: Vec3 = vec3(0, 0, 0),
    rotation: Vec3 = vec3(0, 0, 0),
    scale: Vec3 = vec3(1, 1, 1),
};

const Pipeline = struct {
    gbuffer_pipeline: *gpu.RenderPipeline,
    deferred_rendering_pipeline: *gpu.RenderPipeline,
    gbuffer_bind_group: *gpu.BindGroup,
    gbuffer_texture_bind_group: *gpu.BindGroup,
    lights_bind_group: *gpu.BindGroup,

    pub const Config = struct {
        texture: ?Texture,
    };

    fn deinit(pipeline: *Pipeline) void {
        pipeline.lights_bind_group.release();
        pipeline.gbuffer_bind_group.release();
        pipeline.gbuffer_texture_bind_group.release();
        pipeline.gbuffer_pipeline.release();
        pipeline.deferred_rendering_pipeline.release();
        pipeline.* = undefined;
    }
};

const light_extent_min = vec3(-5, -3, -5);
const light_extent_max = vec3(5, 5, 5);

pub fn init(object: *Object) !void {
    object.deferred_rendering_shader = mach.core.device.createShaderModuleWGSL("deferred_rendering", @embedFile("shaders/deferred_rendering.wgsl"));
    object.write_gbuffer_shader = mach.core.device.createShaderModuleWGSL("write_gbuffers", @embedFile("shaders/write_gbuffers.wgsl"));
    object.camera_uniform = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(shaders.CameraUniform),
        .mapped_at_creation = .false,
    });
    object.lights_buffer = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(shaders.LightBuffer),
        .mapped_at_creation = .false,
    });
    object.instance_buffer = mach.core.device.createBuffer(&.{
        .usage = .{ .vertex = true, .copy_dst = true },
        .size = @sizeOf(shaders.InstanceData) * 1024, // TODO: enough?
        .mapped_at_creation = .false,
    });
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
    _ = config;
    // const marble_texture = try Texture.initFromFile("assets/missing.png");

    // GBuffer
    const gbuffer_bind_group_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &.{
                .{
                    .binding = 0,
                    .visibility = .{ .vertex = true },
                    .buffer = .{
                        .type = .uniform,
                        .has_dynamic_offset = .false,
                        .min_binding_size = @sizeOf(shaders.CameraUniform),
                    },
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
                    .buffer = object.camera_uniform,
                    .size = @sizeOf(shaders.CameraUniform),
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
            .module = object.write_gbuffer_shader,
            .entry_point = "frag_main",
            .targets = &.{
                .{ .format = .rgba16_float },
                .{ .format = .bgra8_unorm },
            },
        }),
        .vertex = gpu.VertexState.init(.{
            .module = object.write_gbuffer_shader,
            .entry_point = "vertex_main",
            .buffers = &.{ Model.Vertex.layout, shaders.InstanceData.layout },
        }),
        .depth_stencil = &.{
            .format = .depth24_plus,
            .depth_write_enabled = .true,
            .depth_compare = .less,
        },
    };
    const gbuffer_pipeline = mach.core.device.createRenderPipeline(&gbuffer_pipeline_descriptor);

    // Deferred-Rendering

    const gbuffer_texture_bind_group_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &.{
                gpu.BindGroupLayout.Entry.texture(0, .{ .fragment = true }, .unfilterable_float, .dimension_2d, false),
                gpu.BindGroupLayout.Entry.texture(1, .{ .fragment = true }, .unfilterable_float, .dimension_2d, false),
                gpu.BindGroupLayout.Entry.texture(2, .{ .fragment = true }, .depth, .dimension_2d, false),
            },
        }),
    );
    defer gbuffer_texture_bind_group_layout.release();

    const gbuffer_texture_bind_group = mach.core.device.createBindGroup(
        &gpu.BindGroup.Descriptor.init(.{
            .layout = gbuffer_texture_bind_group_layout,
            .entries = &.{
                gpu.BindGroup.Entry.textureView(0, renderer.gbuffer_texture_view),
                gpu.BindGroup.Entry.textureView(1, renderer.gbuffer_texture_albedo_view),
                gpu.BindGroup.Entry.textureView(2, renderer.depth_view),
            },
        }),
    );

    const lights_bind_group_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &.{
                gpu.BindGroupLayout.Entry.buffer(0, .{ .fragment = true }, .uniform, false, @sizeOf(shaders.CameraUniform)),
                gpu.BindGroupLayout.Entry.buffer(1, .{ .fragment = true }, .uniform, false, @sizeOf(shaders.LightBuffer)),
            },
        }),
    );
    defer lights_bind_group_layout.release();

    const lights_bind_group = mach.core.device.createBindGroup(
        &gpu.BindGroup.Descriptor.init(.{
            .layout = lights_bind_group_layout,
            .entries = &.{
                .{
                    .binding = 0,
                    .buffer = object.camera_uniform,
                    .size = @sizeOf(shaders.CameraUniform),
                },
                .{
                    .binding = 1,
                    .buffer = object.lights_buffer,
                    .size = @sizeOf(shaders.LightBuffer),
                },
            },
        }),
    );

    const deferred_rendering_pipeline_layout = mach.core.device.createPipelineLayout(
        &gpu.PipelineLayout.Descriptor.init(.{
            .bind_group_layouts = &.{
                gbuffer_texture_bind_group_layout,
                lights_bind_group_layout,
            },
        }),
    );
    const deferred_rendering_pipeline_descriptor = gpu.RenderPipeline.Descriptor{
        .layout = deferred_rendering_pipeline_layout,
        .fragment = &gpu.FragmentState.init(.{
            .module = object.deferred_rendering_shader,
            .entry_point = "frag_main",
            .targets = &.{
                .{
                    .format = .bgra8_unorm,
                    .blend = &.{
                        .color = .{ .operation = .add, .src_factor = .one, .dst_factor = .zero },
                        .alpha = .{ .operation = .add, .src_factor = .one, .dst_factor = .zero },
                    },
                },
            },
        }),
        .vertex = gpu.VertexState.init(.{
            .module = object.deferred_rendering_shader,
            .entry_point = "vertex_main",
            .buffers = &.{},
        }),
    };
    const deferred_rendering_pipeline = mach.core.device.createRenderPipeline(&deferred_rendering_pipeline_descriptor);

    return .{
        .gbuffer_pipeline = gbuffer_pipeline,
        .deferred_rendering_pipeline = deferred_rendering_pipeline,
        .gbuffer_bind_group = gbuffer_bind_group,
        .gbuffer_texture_bind_group = gbuffer_texture_bind_group,
        .lights_bind_group = lights_bind_group,
    };
}

fn getPipeline(object: *Object, renderer: *Renderer, config: Pipeline.Config) !*Pipeline {
    const gop = try object.pipelines.getOrPut(mach.core.allocator, config);
    if (gop.found_existing) return gop.value_ptr;
    gop.value_ptr.* = createPipeline(object, renderer, config);
    return gop.value_ptr;
}

pub fn renderGBuffer(object: *Mod, renderer: *Renderer.Mod, camera: Camera) !void {
    const state: *Object = object.state();
    const renderer_state: *Renderer = renderer.state();

    // Camera Uniform
    mach.core.queue.writeBuffer(
        state.camera_uniform,
        0,
        &[_]shaders.CameraUniform{.{
            .projection_view = camera.projection.mul(&camera.view),
            .inverse_projection_view = math.invert(camera.projection.mul(&camera.view)).transpose(),
        }},
    );

    // Light
    var lights = std.BoundedArray(shaders.Light, shaders.max_num_lights){};
    var archetypes_iter = object.entities.query(.{ .all = &.{.{ .light = &.{ .position, .color, .radius } }} });
    while (archetypes_iter.next()) |archetype| for (
        archetype.slice(.light, .position),
        archetype.slice(.light, .color),
        archetype.slice(.light, .radius),
    ) |position, color, radius| {
        try lights.append(.{
            .position = position,
            .color = color,
            .radius = radius,
        });
    };

    mach.core.queue.writeBuffer(
        state.lights_buffer,
        0,
        &[_]shaders.LightBuffer{.{
            .len = lights.len,
            .lights = lights.buffer,
        }},
    );

    // Instance Data
    var buffer_offset: u32 = 0;
    var object_iter = object.entities.query(.{ .all = &.{.{ .object = &.{ .texture, .model } }} });
    while (object_iter.next()) |archetype| for (
        archetype.slice(.entity, .id),
        archetype.slice(.object, .texture),
        archetype.slice(.object, .model),
    ) |id, texture, model| {
        const transform = object.get(id, .transform);
        const instances = object.get(id, .instances);

        const pipeline = try state.getPipeline(renderer_state, .{ .texture = texture });

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

        renderer_state.gbuffer_pass.setPipeline(pipeline.gbuffer_pipeline);
        renderer_state.gbuffer_pass.setBindGroup(0, pipeline.gbuffer_bind_group, null);
        renderer_state.gbuffer_pass.setVertexBuffer(0, model.vertex_buf, 0, model.vertex_count * @sizeOf(Model.Vertex));
        renderer_state.gbuffer_pass.setVertexBuffer(1, state.instance_buffer, start_offset, transforms.len * @sizeOf(shaders.InstanceData));
        if (model.index_buf) |index_buf| {
            renderer_state.gbuffer_pass.setIndexBuffer(index_buf, .uint32, 0, model.index_count * @sizeOf(u32));
        }

        if (model.index_buf) |_| {
            renderer_state.gbuffer_pass.drawIndexed(model.index_count, @intCast(transforms.len), 0, 0, 0);
        } else {
            renderer_state.gbuffer_pass.draw(model.vertex_count, @intCast(transforms.len), 0, 0);
        }
    };
}

pub fn render(object: *Mod, renderer: *Renderer.Mod) !void {
    const state: *Object = object.state();
    const renderer_state: *Renderer = renderer.state();

    const pipeline = try state.getPipeline(renderer_state, .{ .texture = null }); // TODO

    renderer_state.deferred_pass.setPipeline(pipeline.deferred_rendering_pipeline);
    renderer_state.deferred_pass.setBindGroup(0, pipeline.gbuffer_texture_bind_group, null);
    renderer_state.deferred_pass.setBindGroup(1, pipeline.lights_bind_group, null);
    renderer_state.deferred_pass.draw(6, 1, 0, 0);
}
