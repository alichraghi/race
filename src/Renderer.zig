const std = @import("std");
const mach = @import("mach");
const math = @import("math.zig");
const Camera = @import("Camera.zig");
const Object = @import("Object.zig");
const Light = @import("Light.zig");
const Model = @import("Model.zig");
const Core = mach.Core;
const gpu = mach.gpu;
const Vec3 = math.Vec3;
const vec3 = math.vec3;
const vec4 = math.vec4;

const Renderer = @This();

encoder: *gpu.CommandEncoder = undefined,
gbuffer_pass: *gpu.RenderPassEncoder = undefined,
deferred_pass: *gpu.RenderPassEncoder = undefined,

depth_texture: *gpu.Texture = undefined,
gbuffer_texture: *gpu.Texture = undefined,
gbuffer_texture_albedo: *gpu.Texture = undefined,

back_view: *gpu.TextureView = undefined,
depth_view: *gpu.TextureView = undefined,
gbuffer_texture_view: *gpu.TextureView = undefined,
gbuffer_texture_albedo_view: *gpu.TextureView = undefined,

pub const name = .renderer;
pub const Mod = mach.Mod(Renderer);

pub const global_events = .{
    .framebufferResize = .{ .handler = framebufferResize },
};

pub const local_events = .{
    .record = .{ .handler = record },
    .beginGBuffer = .{ .handler = beginGBuffer },
    .endGBuffer = .{ .handler = endGBuffer },
    .beginDeferred = .{ .handler = beginDeferred },
    .endDeferred = .{ .handler = endDeferred },
    .submit = .{ .handler = submit },
};

pub fn init(state: *Renderer) !void {
    state.createDepthTexture(.{ .width = mach.core.descriptor.width, .height = mach.core.descriptor.height });
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
                .view = state.gbuffer_texture_view,
                .clear_value = .{ .r = 0, .g = 0, .b = 0.7, .a = 1 },
                .load_op = .clear,
                .store_op = .store,
            },
            .{
                .view = state.gbuffer_texture_albedo_view,
                .clear_value = .{ .r = 0, .g = 0.6, .b = 0, .a = 1 },
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

pub fn beginDeferred(renderer: *Mod) void {
    const state: *Renderer = renderer.state();

    state.back_view = mach.core.swap_chain.getCurrentTextureView().?;
    state.deferred_pass = state.encoder.beginRenderPass(
        &gpu.RenderPassDescriptor.init(.{
            .color_attachments = &.{.{
                .view = state.back_view,
                .clear_value = .{ .r = 0.1, .g = 0.1, .b = 0.1, .a = 1 },
                .load_op = .clear,
                .store_op = .store,
            }},
        }),
    );
}

pub fn endDeferred(renderer: *Mod) void {
    const state: *Renderer = renderer.state();

    state.deferred_pass.end();
    state.deferred_pass.release();
    state.back_view.release();
}

pub fn submit(renderer: *Mod) !void {
    const state: *Renderer = renderer.state();

    var command = state.encoder.finish(null);
    defer command.release();
    state.encoder.release();

    mach.core.queue.submit(&[_]*gpu.CommandBuffer{command});
    mach.core.swap_chain.present();
}

pub fn framebufferResize(renderer: *Mod, size: mach.core.Size) void {
    const state: *Renderer = renderer.state();

    state.depth_texture.release();
    state.gbuffer_texture.release();
    state.gbuffer_texture_albedo.release();
    state.gbuffer_texture_view.release();
    state.gbuffer_texture_albedo_view.release();

    state.createDepthTexture(size);
}

pub fn createDepthTexture(state: *Renderer, size: mach.core.Size) void {
    state.depth_texture = mach.core.device.createTexture(&.{
        .size = .{ .width = size.width, .height = size.height },
        .mip_level_count = 1,
        .sample_count = 1,
        .dimension = .dimension_2d,
        .format = .depth24_plus,
        .usage = .{ .texture_binding = true, .render_attachment = true },
    });
    state.gbuffer_texture = mach.core.device.createTexture(&.{
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

    state.depth_view = state.depth_texture.createView(&.{
        .format = .depth24_plus,
        .dimension = .dimension_2d,
        .array_layer_count = 1,
        .aspect = .all,
        .base_array_layer = 0,
    });
    state.gbuffer_texture_view = state.gbuffer_texture.createView(&.{
        .format = .rgba16_float,
        .dimension = .dimension_2d,
        .array_layer_count = 1,
        .aspect = .all,
        .base_array_layer = 0,
    });
    state.gbuffer_texture_albedo_view = state.gbuffer_texture_albedo.createView(&.{
        .format = .bgra8_unorm,
        .dimension = .dimension_2d,
        .array_layer_count = 1,
        .aspect = .all,
        .base_array_layer = 0,
    });
}
