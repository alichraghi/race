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
    .render = .{ .handler = render },
};

pipelines: std.AutoArrayHashMapUnmanaged(PipelineConfig, Pipeline) = .{},
deferred_rendering_shader: *gpu.ShaderModule,
write_gbuffer_shader: *gpu.ShaderModule,
camera_uniform: *gpu.Buffer,
lights_buffer: *gpu.Buffer,
instance_buffer: *gpu.Buffer,

gbuffer_texture: *gpu.Texture,
gbuffer_texture_albedo: *gpu.Texture,
depth_texture: *gpu.Texture,

gbuffer_texture_view: *gpu.TextureView,
gbuffer_texture_albedo_view: *gpu.TextureView,
depth_texture_view: *gpu.TextureView,

pub const Transform = struct {
    translation: Vec3 = vec3(0, 0, 0),
    rotation: Vec3 = vec3(0, 0, 0),
    scale: Vec3 = vec3(1, 1, 1),
};

pub const PipelineConfig = struct {
    texture: ?Texture,
};

const Pipeline = struct {
    gbuffer_pipeline: *gpu.RenderPipeline,
    deferred_rendering_pipeline: *gpu.RenderPipeline,
    gbuffer_bind_group: *gpu.BindGroup,
    gbuffer_texture_bind_group: *gpu.BindGroup,
    lights_bind_group: *gpu.BindGroup,
};

const LightData = extern struct {
    position: Vec3,
    color: Vec4,
    radius: f32,
};

const LightBuffer = extern struct {
    len: u32,
    lights: [10]LightData,
};

const max_num_lights = 10;
const light_extent_min = vec3(-5, -3, -5);
const light_extent_max = vec3(5, 5, 5);

pub fn init(object: *Object) !void {
    const deferred_rendering_shader = mach.core.device.createShaderModuleWGSL("deferred_rendering", @embedFile("shaders/deferred_rendering.wgsl"));
    const write_gbuffer_shader = mach.core.device.createShaderModuleWGSL("write_gbuffers", @embedFile("shaders/write_gbuffers.wgsl"));

    const camera_uniform = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(shaders.CameraUniform),
        .mapped_at_creation = .false,
    });

    const lights_buffer = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(LightBuffer),
        .mapped_at_creation = .false,
    });

    const instance_buffer = mach.core.device.createBuffer(&.{
        .usage = .{ .vertex = true, .copy_dst = true },
        .size = @sizeOf(shaders.InstanceData) * 1024, // TODO: enough?
        .mapped_at_creation = .false,
    });

    const screen_extent = gpu.Extent3D{
        .width = @intCast(mach.core.descriptor.width),
        .height = @intCast(mach.core.descriptor.height),
    };
    const gbuffer_texture = mach.core.device.createTexture(&.{
        .size = screen_extent,
        .format = .rgba16_float,
        .mip_level_count = 1,
        .sample_count = 1,
        .usage = .{
            .texture_binding = true,
            .render_attachment = true,
        },
    });
    const gbuffer_texture_albedo = mach.core.device.createTexture(&.{
        .size = screen_extent,
        .format = .bgra8_unorm,
        .usage = .{
            .texture_binding = true,
            .render_attachment = true,
        },
    });
    const depth_texture = mach.core.device.createTexture(&.{
        .size = screen_extent,
        .mip_level_count = 1,
        .sample_count = 1,
        .dimension = .dimension_2d,
        .format = .depth24_plus,
        .usage = .{
            .texture_binding = true,
            .render_attachment = true,
        },
    });

    var texture_view_descriptor = gpu.TextureView.Descriptor{
        .format = .undefined,
        .dimension = .dimension_2d,
        .array_layer_count = 1,
        .aspect = .all,
        .base_array_layer = 0,
    };

    texture_view_descriptor.format = .rgba16_float;
    const gbuffer_texture_view = gbuffer_texture.createView(&texture_view_descriptor);

    texture_view_descriptor.format = .bgra8_unorm;
    const gbuffer_texture_albedo_view = gbuffer_texture_albedo.createView(&texture_view_descriptor);

    texture_view_descriptor.format = .depth24_plus;
    const depth_texture_view = depth_texture.createView(&texture_view_descriptor);

    object.* = .{
        .deferred_rendering_shader = deferred_rendering_shader,
        .write_gbuffer_shader = write_gbuffer_shader,
        .camera_uniform = camera_uniform,
        .lights_buffer = lights_buffer,
        .instance_buffer = instance_buffer,
        .gbuffer_texture = gbuffer_texture,
        .gbuffer_texture_albedo = gbuffer_texture_albedo,
        .depth_texture = depth_texture,
        .gbuffer_texture_view = gbuffer_texture_view,
        .gbuffer_texture_albedo_view = gbuffer_texture_albedo_view,
        .depth_texture_view = depth_texture_view,
    };
}

pub fn getPipeline(object: *Object, config: PipelineConfig) !*Pipeline {
    const gop = try object.pipelines.getOrPut(mach.core.allocator, config);
    if (gop.found_existing) return gop.value_ptr;

    // const marble_texture = try Texture.initFromFile("assets/missing.png");

    // GBuffer
    const gbuffer_bind_group_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &.{
                gpu.BindGroupLayout.Entry.buffer(0, .{ .vertex = true }, .uniform, false, @sizeOf(shaders.CameraUniform)),
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
                gpu.BindGroup.Entry.textureView(0, object.gbuffer_texture_view),
                gpu.BindGroup.Entry.textureView(1, object.gbuffer_texture_albedo_view),
                gpu.BindGroup.Entry.textureView(2, object.depth_texture_view),
            },
        }),
    );

    const lights_bind_group_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &.{
                gpu.BindGroupLayout.Entry.buffer(0, .{ .fragment = true }, .uniform, false, @sizeOf(shaders.CameraUniform)),
                gpu.BindGroupLayout.Entry.buffer(1, .{ .fragment = true }, .uniform, false, @sizeOf(LightBuffer)),
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
                    .size = @sizeOf(LightBuffer),
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

    gop.value_ptr.* = .{
        .gbuffer_pipeline = gbuffer_pipeline,
        .deferred_rendering_pipeline = deferred_rendering_pipeline,
        .gbuffer_bind_group = gbuffer_bind_group,
        .gbuffer_texture_bind_group = gbuffer_texture_bind_group,
        .lights_bind_group = lights_bind_group,
    };
    return gop.value_ptr;
}

pub fn render(object: *Mod, camera: Camera) !void {
    const state: *Object = object.state();

    const back_buffer_view = mach.core.swap_chain.getCurrentTextureView().?;
    defer back_buffer_view.release();

    const gbuffer_encoder = mach.core.device.createCommandEncoder(&.{});
    defer gbuffer_encoder.release();

    const render_encoder = mach.core.device.createCommandEncoder(&.{});
    defer render_encoder.release();

    const gbuffer_pass = gbuffer_encoder.beginRenderPass(&gpu.RenderPassDescriptor.init(.{
        .color_attachments = &.{
            .{
                .view = state.gbuffer_texture_view,
                .clear_value = .{ .r = 0, .g = 0, .b = 1, .a = 1 },
                .load_op = .clear,
                .store_op = .store,
            },
            .{
                .view = state.gbuffer_texture_albedo_view,
                .clear_value = .{ .r = 0, .g = 0, .b = 0, .a = 1 },
                .load_op = .clear,
                .store_op = .store,
            },
        },
        .depth_stencil_attachment = &.{
            .view = state.depth_texture_view,
            .depth_load_op = .clear,
            .depth_store_op = .store,
            .depth_clear_value = 1.0,
            .stencil_clear_value = 1.0, // NOTE(CULL): remove line
        },
    }));

    // const light_pass = light_encoder.beginComputePass(&.{});

    const color_attachment = gpu.RenderPassColorAttachment{
        .view = back_buffer_view,
        .clear_value = .{ .r = 0.09375, .g = 0.09375, .b = 0.09375, .a = 1 },
        .load_op = .clear,
        .store_op = .store,
    };
    const deferredRenderingPass = render_encoder.beginRenderPass(
        &gpu.RenderPassDescriptor.init(.{ .color_attachments = &.{color_attachment} }),
    );

    // Camera Uniform
    mach.core.queue.writeBuffer(
        state.camera_uniform,
        0,
        &[_]shaders.CameraUniform{.{
            .projection_view = camera.projection.mul(&camera.view),
            .inverse_projection_view = invert(camera.projection.mul(&camera.view)).transpose(),
        }},
    );

    // Light
    var lights = std.BoundedArray(LightData, max_num_lights){};
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
        state.lights_buffer,
        0,
        &[_]LightBuffer{.{
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

        const pipeline = try state.getPipeline(.{ .texture = texture });

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

        gbuffer_pass.setPipeline(pipeline.gbuffer_pipeline);
        gbuffer_pass.setBindGroup(0, pipeline.gbuffer_bind_group, null);
        gbuffer_pass.setVertexBuffer(0, model.vertex_buf, 0, model.vertex_count * @sizeOf(Model.Vertex));
        gbuffer_pass.setVertexBuffer(1, state.instance_buffer, start_offset, transforms.len * @sizeOf(shaders.InstanceData));
        if (model.index_buf) |index_buf| {
            gbuffer_pass.setIndexBuffer(index_buf, .uint32, 0, model.index_count * @sizeOf(u32));
        }

        if (model.index_buf) |_| {
            gbuffer_pass.drawIndexed(model.index_count, @intCast(transforms.len), 0, 0, 0);
        } else {
            gbuffer_pass.draw(model.vertex_count, @intCast(transforms.len), 0, 0);
        }

        // Deferred rendering

        deferredRenderingPass.setPipeline(pipeline.deferred_rendering_pipeline);
        deferredRenderingPass.setBindGroup(0, pipeline.gbuffer_texture_bind_group, null);
        deferredRenderingPass.setBindGroup(1, pipeline.lights_bind_group, null);
        deferredRenderingPass.draw(6, 1, 0, 0);
    };

    gbuffer_pass.end();
    gbuffer_pass.release();

    deferredRenderingPass.end();
    deferredRenderingPass.release();

    var gbuffer_command = gbuffer_encoder.finish(null);
    defer gbuffer_command.release();

    var render_command = render_encoder.finish(null);
    defer render_command.release();

    mach.core.queue.submit(&[_]*gpu.CommandBuffer{ gbuffer_command, render_command });

    // Prepare for next pass
    mach.core.swap_chain.present();
}

pub fn invert(a: Mat4x4) Mat4x4 {
    const a00 = a.v[0].v[0];
    const a01 = a.v[0].v[1];
    const a02 = a.v[0].v[2];
    const a03 = a.v[0].v[3];
    const a10 = a.v[1].v[0];
    const a11 = a.v[1].v[1];
    const a12 = a.v[1].v[2];
    const a13 = a.v[1].v[3];
    const a20 = a.v[2].v[0];
    const a21 = a.v[2].v[1];
    const a22 = a.v[2].v[2];
    const a23 = a.v[2].v[3];
    const a30 = a.v[3].v[0];
    const a31 = a.v[3].v[1];
    const a32 = a.v[3].v[2];
    const a33 = a.v[3].v[3];

    const b00 = a00 * a11 - a01 * a10;
    const b01 = a00 * a12 - a02 * a10;
    const b02 = a00 * a13 - a03 * a10;
    const b03 = a01 * a12 - a02 * a11;
    const b04 = a01 * a13 - a03 * a11;
    const b05 = a02 * a13 - a03 * a12;
    const b06 = a20 * a31 - a21 * a30;
    const b07 = a20 * a32 - a22 * a30;
    const b08 = a20 * a33 - a23 * a30;
    const b09 = a21 * a32 - a22 * a31;
    const b10 = a21 * a33 - a23 * a31;
    const b11 = a22 * a33 - a23 * a32;

    // Calculate the determinant
    var det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;

    det = 1.0 / det;

    const out = mat4x4(
        &vec4(
            (a11 * b11 - a12 * b10 + a13 * b09) * det, // 0
            (a02 * b10 - a01 * b11 - a03 * b09) * det, // 1
            (a31 * b05 - a32 * b04 + a33 * b03) * det, // 2
            (a22 * b04 - a21 * b05 - a23 * b03) * det, // 3
        ),
        &vec4(
            (a12 * b08 - a10 * b11 - a13 * b07) * det, // 4
            (a00 * b11 - a02 * b08 + a03 * b07) * det, // 5
            (a32 * b02 - a30 * b05 - a33 * b01) * det, // 6
            (a20 * b05 - a22 * b02 + a23 * b01) * det, // 7
        ),
        &vec4(
            (a10 * b10 - a11 * b08 + a13 * b06) * det, // 8
            (a01 * b08 - a00 * b10 - a03 * b06) * det, // 9
            (a30 * b04 - a31 * b02 + a33 * b00) * det, // 10
            (a21 * b02 - a20 * b04 - a23 * b00) * det, // 11
        ),
        &vec4(
            (a11 * b07 - a10 * b09 - a12 * b06) * det, // 12
            (a00 * b09 - a01 * b07 + a02 * b06) * det, // 13
            (a31 * b01 - a30 * b03 - a32 * b00) * det, // 14
            (a20 * b03 - a21 * b01 + a22 * b00) * det, // 15
        ),
    );

    return out;
}
