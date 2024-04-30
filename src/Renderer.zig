const std = @import("std");
const mach = @import("mach");
const math = @import("math.zig");
const Camera = @import("Camera.zig");
const Object = @import("Object.zig");
const Light = @import("Light.zig");
const Model = @import("Model.zig");
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
gbuffer_texture_metallic: *gpu.Texture = undefined,
gbuffer_texture_roughness: *gpu.Texture = undefined,
gbuffer_texture_positions: *gpu.Texture = undefined,

back_view: *gpu.TextureView = undefined,
depth_view: *gpu.TextureView = undefined,
gbuffer_texture_albedo_view: *gpu.TextureView = undefined,
gbuffer_texture_normal_view: *gpu.TextureView = undefined,
gbuffer_texture_metallic_view: *gpu.TextureView = undefined,
gbuffer_texture_roughness_view: *gpu.TextureView = undefined,
gbuffer_texture_positions_view: *gpu.TextureView = undefined,

encoder: *gpu.CommandEncoder = undefined,
gbuffer_pass: *gpu.RenderPassEncoder = undefined,
quad_pass: *gpu.RenderPassEncoder = undefined,

pub const name = .renderer;
pub const Mod = mach.Mod(Renderer);

pub const global_events = .{
    .rendererFramebufferResize = .{ .handler = rendererFramebufferResize },
};

pub const local_events = .{
    .record = .{ .handler = record },
    .writeCamera = .{ .handler = writeCamera },
    .writeLights = .{ .handler = writeLights },
    .writeRenderMode = .{ .handler = writeRenderMode },
    .beginGBuffer = .{ .handler = beginGBuffer },
    .endGBuffer = .{ .handler = endGBuffer },
    .beginQuad = .{ .handler = beginQuad },
    .renderQuad = .{ .handler = renderQuad },
    .endQuad = .{ .handler = endQuad },
    .submit = .{ .handler = submit },
};

pub fn init(state: *Renderer) !void {
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

    state.createTextures(.{ .width = mach.core.descriptor.width, .height = mach.core.descriptor.height });
    state.createQuadRenderPipeline();
}

pub fn deinit(renderer: *Mod) !void {
    const state: *Renderer = renderer.state();

    state.depth_texture.release();
    state.depth_view.release();
}

pub fn record(renderer: *Mod) void {
    const state: *Renderer = renderer.state();

    state.encoder = mach.core.device.createCommandEncoder(&.{});
}

pub fn beginGBuffer(renderer: *Mod) void {
    const state: *Renderer = renderer.state();

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
            .{
                .view = state.gbuffer_texture_metallic_view,
                .clear_value = .{ .r = 1, .g = 0, .b = 0, .a = 1 },
                .load_op = .clear,
                .store_op = .store,
            },
            .{
                .view = state.gbuffer_texture_roughness_view,
                .clear_value = .{ .r = 0, .g = 1, .b = 0, .a = 1 },
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
}

pub fn endGBuffer(renderer: *Mod) void {
    const state: *Renderer = renderer.state();

    state.gbuffer_pass.end();
    state.gbuffer_pass.release();
}

pub fn beginQuad(renderer: *Mod) void {
    const state: *Renderer = renderer.state();

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
}

pub fn renderQuad(renderer: *Mod) !void {
    const state: *Renderer = renderer.state();

    state.quad_pass.setBindGroup(0, state.bind_group_0, null);
    if (state.render_mode == .render) {
        state.quad_pass.setPipeline(state.quad_pipeline);
        state.quad_pass.setBindGroup(1, state.bind_group_1, null);
    } else {
        state.quad_pass.setPipeline(state.quad_debug_pipeline);
        state.quad_pass.setBindGroup(1, state.bind_group_1_debug, null);
    }
    state.quad_pass.draw(6, 1, 0, 0);
}

pub fn endQuad(renderer: *Mod) void {
    const state: *Renderer = renderer.state();

    state.quad_pass.end();
    state.quad_pass.release();
    state.back_view.release();
}

var cam: Camera = undefined;
pub fn writeCamera(renderer: *Mod, camera: Camera) !void {
    const state: *Renderer = renderer.state();

    cam = camera;
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
}

pub fn writeMaterialConfig(renderer: *Mod, config: shaders.MaterialConfig, index: u32) !void {
    const state: *Renderer = renderer.state();

    mach.core.queue.writeBuffer(
        state.material_config_uniform,
        index * @sizeOf(shaders.MaterialConfig),
        &[_]shaders.MaterialConfig{config},
    );
}

pub fn writeLights(renderer: *Mod) !void {
    const state: *Renderer = renderer.state();

    var lights = std.BoundedArray(shaders.Light, shaders.max_num_lights){};
    var archetypes_iter = renderer.entities.query(.{ .all = &.{.{ .light = &.{ .position, .color, .radius } }} });
    while (archetypes_iter.next()) |archetype| for (
        archetype.slice(.light, .position),
        archetype.slice(.light, .color),
        archetype.slice(.light, .radius),
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
}

pub fn writeRenderMode(renderer: *Mod, mode: shaders.RenderMode) !void {
    const state: *Renderer = renderer.state();

    state.render_mode = mode;
    mach.core.queue.writeBuffer(state.render_mode_uniform, 0, &[_]shaders.RenderMode{mode});
}

pub fn submit(renderer: *Mod) !void {
    const state: *Renderer = renderer.state();

    var command = state.encoder.finish(null);
    defer command.release();
    state.encoder.release();

    mach.core.queue.submit(&[_]*gpu.CommandBuffer{command});
    mach.core.swap_chain.present();
}

pub fn rendererFramebufferResize(renderer: *Mod, size: mach.core.Size) void {
    const state: *Renderer = renderer.state();

    state.depth_texture.release();
    state.gbuffer_texture_normal.release();
    state.gbuffer_texture_albedo.release();
    state.gbuffer_texture_metallic.release();
    state.gbuffer_texture_roughness.release();
    state.gbuffer_texture_positions.release();
    state.gbuffer_texture_normal_view.release();
    state.gbuffer_texture_albedo_view.release();
    state.gbuffer_texture_metallic_view.release();
    state.gbuffer_texture_roughness_view.release();
    state.gbuffer_texture_positions_view.release();

    state.createTextures(size);
    state.createQuadRenderPipeline();
}

fn createQuadRenderPipeline(state: *Renderer) void {
    const bind_group_0_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &.{
                gpu.BindGroupLayout.Entry.texture(0, .{ .fragment = true }, .unfilterable_float, .dimension_2d, false),
                gpu.BindGroupLayout.Entry.texture(1, .{ .fragment = true }, .unfilterable_float, .dimension_2d, false),
                gpu.BindGroupLayout.Entry.texture(2, .{ .fragment = true }, .depth, .dimension_2d, false),
                gpu.BindGroupLayout.Entry.texture(3, .{ .fragment = true }, .unfilterable_float, .dimension_2d, false),
                gpu.BindGroupLayout.Entry.texture(4, .{ .fragment = true }, .unfilterable_float, .dimension_2d, false),
                gpu.BindGroupLayout.Entry.sampler(5, .{ .fragment = true }, .filtering),
                gpu.BindGroupLayout.Entry.texture(6, .{ .fragment = true }, .unfilterable_float, .dimension_2d, false),
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
                .{ .binding = 3, .texture_view = state.gbuffer_texture_metallic_view, .size = 0 },
                .{ .binding = 4, .texture_view = state.gbuffer_texture_roughness_view, .size = 0 },
                .{ .binding = 5, .sampler = state.gbuffer_sampler, .size = 0 },
                .{ .binding = 6, .texture_view = state.gbuffer_texture_positions_view, .size = 0 },
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
    state.gbuffer_texture_metallic = mach.core.device.createTexture(&.{
        .size = .{ .width = size.width, .height = size.height },
        .format = .r8_unorm,
        .usage = .{
            .texture_binding = true,
            .render_attachment = true,
        },
    });
    state.gbuffer_texture_roughness = mach.core.device.createTexture(&.{
        .size = .{ .width = size.width, .height = size.height },
        .format = .r8_unorm,
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
    state.gbuffer_texture_metallic_view = state.gbuffer_texture_metallic.createView(&.{
        .label = "gbuffer_texture_metallic_view",
        .format = .r8_unorm,
        .dimension = .dimension_2d,
        .array_layer_count = 1,
        .aspect = .all,
        .base_array_layer = 0,
    });
    state.gbuffer_texture_roughness_view = state.gbuffer_texture_roughness.createView(&.{
        .label = "gbuffer_texture_roughness_view",
        .format = .r8_unorm,
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
