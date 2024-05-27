const std = @import("std");
const mach = @import("mach");
const math = @import("math.zig");
const Camera = @import("Camera.zig");
const Object = @import("Object.zig");
const Light = @import("Light.zig");
const Model = @import("Model.zig");
const Texture = @import("Texture.zig");
const shaders = @import("shaders.zig");
const Core = mach.Core;
const gpu = mach.gpu;
const Vec3 = math.Vec3;
const vec3 = math.vec3;
const vec4 = math.vec4;

const Renderer = @This();

render_mode: shaders.RenderMode = .render,

quad_shader: *gpu.ShaderModule = undefined,
quad_debug_shader: *gpu.ShaderModule = undefined,

bind_group_0: *gpu.BindGroup = undefined,
bind_group_1: *gpu.BindGroup = undefined,
quad_pipeline: *gpu.RenderPipeline = undefined,

bind_group_1_debug: *gpu.BindGroup = undefined,
quad_debug_pipeline: *gpu.RenderPipeline = undefined,

camera_uniform: *gpu.Buffer = undefined,
lights_buffer: *gpu.Buffer = undefined,
render_mode_uniform: *gpu.Buffer = undefined,

gbuffer_sampler: *gpu.Sampler = undefined,
depth_texture: *gpu.Texture = undefined,
gbuffer_texture_albedo: *gpu.Texture = undefined,
gbuffer_texture_normal: *gpu.Texture = undefined,
gbuffer_texture_positions: *gpu.Texture = undefined,

back_view: *gpu.TextureView = undefined,
depth_view: *gpu.TextureView = undefined,
gbuffer_texture_albedo_view: *gpu.TextureView = undefined,
gbuffer_texture_normal_view: *gpu.TextureView = undefined,
gbuffer_texture_positions_view: *gpu.TextureView = undefined,

encoder: *gpu.CommandEncoder = undefined,
gbuffer_pass: *gpu.RenderPassEncoder = undefined,
quad_pass: *gpu.RenderPassEncoder = undefined,

pipelines: std.ArrayHashMapUnmanaged(Pipeline.Config, Pipeline, Pipeline.Config.ArrayHashContext, false) = .{},
gbuffers_shader: *gpu.ShaderModule = undefined,
instance_buffer: *gpu.Buffer = undefined,
default_material: Model.Material = undefined,

pub const name = .renderer;
pub const Mod = mach.Mod(Renderer);

pub const systems = .{
    .init = .{ .handler = init },
    .renderObjects = .{ .handler = renderObjects },
    .render = .{ .handler = render },
    .framebufferResize = .{ .handler = framebufferResize },
};

pub fn init(renderer: *Mod) !void {
    const state = renderer.state();

    state.quad_shader = mach.core.device.createShaderModuleWGSL("quad", @embedFile("shaders/quad.wgsl"));
    state.quad_debug_shader = mach.core.device.createShaderModuleWGSL("quad_debug", @embedFile("shaders/quad_debug.wgsl"));

    state.camera_uniform = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(shaders.CameraUniform),
        .mapped_at_creation = .false,
    });
    state.lights_buffer = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(shaders.LightBuffer),
        .mapped_at_creation = .false,
    });
    state.render_mode_uniform = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(shaders.RenderMode),
        .mapped_at_creation = .false,
    });
    state.gbuffer_sampler = mach.core.device.createSampler(&.{
        .mag_filter = .nearest,
        .min_filter = .nearest,
    }); // TODO: linear is correct?

    state.gbuffers_shader = mach.core.device.createShaderModuleWGSL("gbuffers", @embedFile("shaders/gbuffers.wgsl"));
    state.instance_buffer = mach.core.device.createBuffer(&.{
        .usage = .{ .vertex = true, .copy_dst = true },
        .size = @sizeOf(shaders.InstanceData) * max_scene_objects,
        .mapped_at_creation = .false,
    });
    state.default_material = .{
        .name = "Default Material",
        .texture = try Texture.init(1, 1, .rgba, &.{ 255, 128, 128, 255 }),
        .normal = try Texture.init(1, 1, .rgba, &.{ 128, 128, 255, 255 }),
    };

    state.createTextures(.{ .width = mach.core.descriptor.width, .height = mach.core.descriptor.height });
    state.createQuadRenderPipeline();
}

pub fn deinit(renderer: *Mod) !void {
    const state: *Renderer = renderer.state();

    state.depth_texture.release();
    state.depth_view.release();
    for (state.pipelines.values()) |pipeline| {
        pipeline.deinit();
    }
}

pub fn render(
    renderer: *Mod,
    entities: *mach.Entities.Mod,
    object: *Object.Mod,
    light: *Light.Mod,
    core: *Core.Mod,
    camera: Camera,
) !void {
    const state: *Renderer = renderer.state();

    state.encoder = mach.core.device.createCommandEncoder(&.{});
    state.gbuffer_pass = state.encoder.beginRenderPass(&gpu.RenderPassDescriptor.init(.{
        .color_attachments = &.{
            .{
                .view = state.gbuffer_texture_positions_view,
                .clear_value = .{ .r = 0, .g = 1, .b = 0, .a = 1 },
                .load_op = .clear,
                .store_op = .store,
            },
            .{
                .view = state.gbuffer_texture_normal_view,
                .clear_value = .{ .r = 0, .g = 0, .b = 0.7, .a = 1 },
                .load_op = .clear,
                .store_op = .store,
            },
            .{
                .view = state.gbuffer_texture_albedo_view,
                .clear_value = .{ .r = 0.5, .g = 0.5, .b = 0.5, .a = 1 },
                .load_op = .clear,
                .store_op = .store,
            },
        },
        .depth_stencil_attachment = &.{
            .view = state.depth_view,
            .depth_load_op = .clear,
            .depth_store_op = .store,
            .depth_clear_value = 1.0,
        },
    }));

    mach.core.queue.writeBuffer(state.render_mode_uniform, 0, &[_]shaders.RenderMode{state.render_mode});
    mach.core.queue.writeBuffer(
        state.camera_uniform,
        0,
        &[_]shaders.CameraUniform{.{
            .position = camera.position,
            .view = camera.view,
            .projection_view = camera.projection.mul(&camera.view),
            .inverse_projection_view = math.inverse(camera.projection),
        }},
    );

    var lights = std.BoundedArray(shaders.Light, shaders.max_num_lights){};
    var q = try entities.query(.{
        .positions = Light.Mod.read(.position),
        .colors = Light.Mod.read(.color),
        .radiuses = Light.Mod.read(.radius),
    });
    while (q.next()) |v| for (
        v.positions,
        v.colors,
        v.radiuses,
    ) |position, color, radius| {
        // const pos = cam.projection.mul(&cam.view).mulVec(&vec4(position.x(), position.y(), position.z(), 1));
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

    try state.renderObjects(object, entities);

    state.gbuffer_pass.end();
    state.gbuffer_pass.release();

    state.back_view = mach.core.swap_chain.getCurrentTextureView().?;
    state.quad_pass = state.encoder.beginRenderPass(
        &gpu.RenderPassDescriptor.init(.{
            .color_attachments = &.{.{
                .view = state.back_view,
                .clear_value = .{ .r = 0, .g = 0, .b = 0, .a = 1 },
                .load_op = .clear,
                .store_op = .store,
            }},
        }),
    );

    state.quad_pass.setBindGroup(0, state.bind_group_0, null);
    if (state.render_mode == .render) {
        state.quad_pass.setPipeline(state.quad_pipeline);
        state.quad_pass.setBindGroup(1, state.bind_group_1, null);
    } else {
        state.quad_pass.setPipeline(state.quad_debug_pipeline);
        state.quad_pass.setBindGroup(1, state.bind_group_1_debug, null);
    }
    state.quad_pass.draw(6, 1, 0, 0);

    _ = light;
    // light.schedule(.render);

    state.quad_pass.end();
    state.quad_pass.release();
    state.back_view.release();

    var command = state.encoder.finish(null);
    defer command.release();
    state.encoder.release();

    mach.core.queue.submit(&[_]*gpu.CommandBuffer{command});

    core.schedule(.present_frame);
}

const Pipeline = struct {
    gbuffer_pipeline: *gpu.RenderPipeline,
    gbuffer_bind_group: *gpu.BindGroup,

    pub const Config = struct {
        material: Model.Material,

        pub const ArrayHashContext = struct {
            pub fn eql(ctx: ArrayHashContext, a: Config, b: Config, _: usize) bool {
                _ = ctx;

                var eql_normal = false;
                if (a.material.normal != null and b.material.normal != null) {
                    eql_normal = a.material.normal.?.view == b.material.normal.?.view;
                } else if (a.material.normal == null and b.material.normal == null) {
                    eql_normal = true;
                }

                // NOTE: We don't compare float values but this should be enough
                return a.material.texture.view == b.material.texture.view and
                    std.mem.eql(u8, a.material.name, b.material.name) and eql_normal;
            }

            pub fn hash(ctx: ArrayHashContext, a: Config) u32 {
                _ = ctx;
                var xx32 = std.hash.XxHash32.init(0);
                xx32.update(a.material.name);
                xx32.update(&std.mem.toBytes(@intFromPtr(a.material.texture.view)));
                if (a.material.normal) |normal| {
                    xx32.update(&std.mem.toBytes(@intFromPtr(normal.view)));
                }
                return xx32.final();
            }
        };
    };

    fn deinit(pipeline: Pipeline) void {
        pipeline.gbuffer_pipeline.release();
        pipeline.gbuffer_bind_group.release();
    }
};

const max_scene_objects = 1024;

fn createPipeline(renderer: *Renderer, config: Pipeline.Config) Pipeline {
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
                    .texture = .{
                        .sample_type = .float,
                        .view_dimension = .dimension_2d,
                        .multisampled = .false,
                    },
                },
                .{
                    .binding = 3,
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
                    .texture_view = config.material.normal.?.view,
                    .size = 0,
                },
                .{
                    .binding = 3,
                    .sampler = config.material.texture.sampler,
                    .size = 0,
                },
            },
        }),
    );

    const gbuffer_pipeline_layout = mach.core.device.createPipelineLayout(
        &gpu.PipelineLayout.Descriptor.init(.{ .bind_group_layouts = &.{gbuffer_bind_group_layout} }),
    );
    const gbuffer_pipeline = mach.core.device.createRenderPipeline(&.{
        .layout = gbuffer_pipeline_layout,
        .fragment = &gpu.FragmentState.init(.{
            .module = renderer.gbuffers_shader,
            .entry_point = "frag_main",
            .targets = &.{
                .{ .format = .rgba16_float },
                .{ .format = .rgba16_float },
                .{ .format = .bgra8_unorm },
            },
        }),
        .vertex = gpu.VertexState.init(.{
            .module = renderer.gbuffers_shader,
            .entry_point = "vertex_main",
            .buffers = &.{ shaders.Vertex.layout, shaders.InstanceData.layout },
        }),
        .depth_stencil = &.{
            .format = .depth24_plus,
            .depth_write_enabled = .true,
            .depth_compare = .less,
        },
    });

    return .{ .gbuffer_pipeline = gbuffer_pipeline, .gbuffer_bind_group = gbuffer_bind_group };
}

fn getPipeline(renderer: *Renderer, config: Pipeline.Config) !*Pipeline {
    const gop = try renderer.pipelines.getOrPut(mach.core.allocator, config);
    if (gop.found_existing) return gop.value_ptr;
    gop.value_ptr.* = renderer.createPipeline(config);
    return gop.value_ptr;
}

pub fn renderObjects(renderer: *Renderer, object: *Object.Mod, entities: *mach.Entities.Mod) !void {
    // Instance Data
    var instance_buffer_offset: u32 = 0;
    var q = try entities.query(.{
        .ids = mach.Entities.Mod.read(.id),
        .models = Object.Mod.read(.model),
    });
    while (q.next()) |v| for (v.ids, v.models) |id, model| {
        const transform = object.get(id, .transform);
        const instances = object.get(id, .instances);

        const transforms = if (transform) |single| &.{single} else instances.?;
        std.debug.assert(transforms.len > 0);

        const instance_start_offset = instance_buffer_offset;
        for (transforms) |instance| {
            // writeBuffer is just a @memcpy
            mach.core.queue.writeBuffer(
                renderer.instance_buffer,
                instance_buffer_offset,
                &[_]shaders.InstanceData{.{
                    .model = math.transform(instance.translation, instance.rotation, instance.scale),
                    // .model_normal = math.inverse(math.transform(instance.translation, instance.rotation, instance.scale)),
                    .model_normal = math.transformNormal(instance.rotation, instance.scale),
                }},
            );
            instance_buffer_offset += @sizeOf(shaders.InstanceData);
        }

        renderer.gbuffer_pass.setVertexBuffer(1, renderer.instance_buffer, instance_start_offset, transforms.len * @sizeOf(shaders.InstanceData));

        for (model.meshes) |mesh| {
            const material = if (mesh.material) |material| model.materials[material] else renderer.default_material;
            const pipeline = try renderer.getPipeline(.{ .material = material });

            renderer.gbuffer_pass.setPipeline(pipeline.gbuffer_pipeline);
            renderer.gbuffer_pass.setBindGroup(0, pipeline.gbuffer_bind_group, &.{});
            renderer.gbuffer_pass.setVertexBuffer(0, mesh.vertex_buf, 0, mesh.vertex_count * @sizeOf(shaders.Vertex));
            if (mesh.index_buf) |index_buf| {
                renderer.gbuffer_pass.setIndexBuffer(index_buf, .uint32, 0, mesh.index_count * @sizeOf(u32));
            }

            if (mesh.index_buf) |_| {
                renderer.gbuffer_pass.drawIndexed(mesh.index_count, @intCast(transforms.len), 0, 0, 0);
            } else {
                renderer.gbuffer_pass.draw(mesh.vertex_count, @intCast(transforms.len), 0, 0);
            }
        }
    };
}

pub fn framebufferResize(renderer: *Mod, size: mach.core.Size) void {
    const state: *Renderer = renderer.state();

    state.depth_texture.release();
    state.gbuffer_texture_normal.release();
    state.gbuffer_texture_albedo.release();
    state.gbuffer_texture_positions.release();
    state.gbuffer_texture_normal_view.release();
    state.gbuffer_texture_albedo_view.release();
    state.gbuffer_texture_positions_view.release();

    state.createTextures(size);
    state.createQuadRenderPipeline();

    for (state.pipelines.keys(), state.pipelines.values()) |config, *pipeline| {
        pipeline.deinit();
        pipeline.* = state.createPipeline(config);
    }
}

fn createQuadRenderPipeline(state: *Renderer) void {
    const bind_group_0_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &.{
                gpu.BindGroupLayout.Entry.texture(0, .{ .fragment = true }, .unfilterable_float, .dimension_2d, false),
                gpu.BindGroupLayout.Entry.texture(1, .{ .fragment = true }, .unfilterable_float, .dimension_2d, false),
                gpu.BindGroupLayout.Entry.texture(2, .{ .fragment = true }, .depth, .dimension_2d, false),
                gpu.BindGroupLayout.Entry.sampler(3, .{ .fragment = true }, .filtering),
                gpu.BindGroupLayout.Entry.texture(4, .{ .fragment = true }, .unfilterable_float, .dimension_2d, false),
            },
        }),
    );
    defer bind_group_0_layout.release();

    const bind_group_1_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &.{
                gpu.BindGroupLayout.Entry.buffer(0, .{ .fragment = true }, .uniform, false, @sizeOf(shaders.CameraUniform)),
                gpu.BindGroupLayout.Entry.buffer(1, .{ .fragment = true }, .uniform, false, @sizeOf(shaders.LightBuffer)),
            },
        }),
    );
    defer bind_group_1_layout.release();

    state.bind_group_0 = mach.core.device.createBindGroup(
        &gpu.BindGroup.Descriptor.init(.{
            .layout = bind_group_0_layout,
            .entries = &.{
                .{ .binding = 0, .texture_view = state.gbuffer_texture_normal_view, .size = 0 },
                .{ .binding = 1, .texture_view = state.gbuffer_texture_albedo_view, .size = 0 },
                .{ .binding = 2, .texture_view = state.depth_view, .size = 0 },
                .{ .binding = 3, .sampler = state.gbuffer_sampler, .size = 0 },
                .{ .binding = 4, .texture_view = state.gbuffer_texture_positions_view, .size = 0 },
            },
        }),
    );
    state.bind_group_1 = mach.core.device.createBindGroup(
        &gpu.BindGroup.Descriptor.init(.{
            .layout = bind_group_1_layout,
            .entries = &.{
                .{ .binding = 0, .buffer = state.camera_uniform, .size = @sizeOf(shaders.CameraUniform) },
                .{ .binding = 1, .buffer = state.lights_buffer, .size = @sizeOf(shaders.LightBuffer) },
            },
        }),
    );

    const quad_pipeline_layout = mach.core.device.createPipelineLayout(
        &gpu.PipelineLayout.Descriptor.init(.{
            .bind_group_layouts = &.{ bind_group_0_layout, bind_group_1_layout },
        }),
    );
    state.quad_pipeline = mach.core.device.createRenderPipeline(&.{
        .layout = quad_pipeline_layout,
        .fragment = &gpu.FragmentState.init(.{
            .module = state.quad_shader,
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
            .module = state.quad_shader,
            .entry_point = "vertex_main",
            .buffers = &.{},
        }),
    });

    // Debug Pipeline

    const bind_group_1_debug_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &.{
                gpu.BindGroupLayout.Entry.buffer(0, .{ .fragment = true }, .uniform, false, @sizeOf(shaders.RenderMode)),
            },
        }),
    );
    defer bind_group_1_debug_layout.release();

    state.bind_group_1_debug = mach.core.device.createBindGroup(
        &gpu.BindGroup.Descriptor.init(.{
            .layout = bind_group_1_debug_layout,
            .entries = &.{
                .{ .binding = 0, .buffer = state.render_mode_uniform, .size = @sizeOf(shaders.RenderMode) },
            },
        }),
    );

    const quad_debug_pipeline_layout = mach.core.device.createPipelineLayout(
        &gpu.PipelineLayout.Descriptor.init(.{
            .bind_group_layouts = &.{ bind_group_0_layout, bind_group_1_debug_layout },
        }),
    );
    state.quad_debug_pipeline = mach.core.device.createRenderPipeline(&.{
        .layout = quad_debug_pipeline_layout,
        .fragment = &gpu.FragmentState.init(.{
            .module = state.quad_debug_shader,
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
            .module = state.quad_debug_shader,
            .entry_point = "vertex_main",
            .buffers = &.{},
        }),
    });
}

pub fn createTextures(state: *Renderer, size: mach.core.Size) void {
    state.depth_texture = mach.core.device.createTexture(&.{
        .size = .{ .width = size.width, .height = size.height },
        .mip_level_count = 1,
        .sample_count = 1,
        .dimension = .dimension_2d,
        .format = .depth24_plus,
        .usage = .{ .texture_binding = true, .render_attachment = true },
    });
    state.gbuffer_texture_normal = mach.core.device.createTexture(&.{
        .size = .{ .width = size.width, .height = size.height },
        .format = .rgba16_float,
        .mip_level_count = 1,
        .sample_count = 1,
        .usage = .{
            .texture_binding = true,
            .render_attachment = true,
        },
    });
    state.gbuffer_texture_albedo = mach.core.device.createTexture(&.{
        .size = .{ .width = size.width, .height = size.height },
        .format = .bgra8_unorm,
        .usage = .{
            .texture_binding = true,
            .render_attachment = true,
        },
    });
    state.gbuffer_texture_positions = mach.core.device.createTexture(&.{
        .size = .{ .width = size.width, .height = size.height },
        .format = .rgba16_float,
        .usage = .{
            .texture_binding = true,
            .render_attachment = true,
        },
    });

    state.depth_view = state.depth_texture.createView(&.{
        .label = "depth_view",
        .format = .depth24_plus,
        .dimension = .dimension_2d,
        .array_layer_count = 1,
        .aspect = .all,
        .base_array_layer = 0,
    });
    state.gbuffer_texture_normal_view = state.gbuffer_texture_normal.createView(&.{
        .label = "gbuffer_texture_normal_view",
        .format = .rgba16_float,
        .dimension = .dimension_2d,
        .array_layer_count = 1,
        .aspect = .all,
        .base_array_layer = 0,
    });
    state.gbuffer_texture_albedo_view = state.gbuffer_texture_albedo.createView(&.{
        .label = "gbuffer_texture_albedo_view",
        .format = .bgra8_unorm,
        .dimension = .dimension_2d,
        .array_layer_count = 1,
        .aspect = .all,
        .base_array_layer = 0,
    });
    state.gbuffer_texture_positions_view = state.gbuffer_texture_positions.createView(&.{
        .label = "gbuffer_texture_positions_view",
        .format = .rgba16_float,
        .dimension = .dimension_2d,
        .array_layer_count = 1,
        .aspect = .all,
        .base_array_layer = 0,
    });
}
