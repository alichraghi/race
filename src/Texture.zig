const std = @import("std");
const mach = @import("mach");
const zigimg = @import("zigimg");
const core = mach.core;
const gpu = mach.gpu;

const Texture = @This();

sampler: *gpu.Sampler,
view: *gpu.TextureView,

pub fn initFromFile(path: []const u8) !Texture {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    const data = try file.readToEndAlloc(core.allocator, 1024 * 1024 * 1024);
    defer core.allocator.free(data);
    return init(data);
}

pub fn init(data: []const u8) !Texture {
    var img = try zigimg.Image.fromMemory(core.allocator, data);
    defer img.deinit();

    const size = gpu.Extent3D{
        .width = @intCast(img.width),
        .height = @intCast(img.height),
    };

    const data_layout = gpu.Texture.DataLayout{
        .bytes_per_row = @intCast(img.width * 4),
        .rows_per_image = @intCast(img.height),
    };

    const texture = core.device.createTexture(&.{
        .size = size,
        .format = .rgba8_unorm,
        .usage = .{
            .texture_binding = true,
            .copy_dst = true,
            .render_attachment = true,
        },
    });
    defer texture.release();

    switch (img.pixels) {
        .rgba32 => |pixels| core.queue.writeTexture(&.{ .texture = texture }, &data_layout, &size, pixels),
        .rgb24 => |pixels| {
            const rgba32_pixels = try rgb24ToRgba32(pixels);
            defer rgba32_pixels.deinit(core.allocator);
            core.queue.writeTexture(&.{ .texture = texture }, &data_layout, &size, rgba32_pixels.rgba32);
        },
        else => @panic("unsupported image color format"),
    }

    const sampler = core.device.createSampler(&.{ .mag_filter = .linear, .min_filter = .linear });
    const view = texture.createView(&gpu.TextureView.Descriptor{});

    return .{
        .sampler = sampler,
        .view = view,
    };
}

fn rgb24ToRgba32(in: []zigimg.color.Rgb24) !zigimg.color.PixelStorage {
    const out = try zigimg.color.PixelStorage.init(core.allocator, .rgba32, in.len);
    for (out.rgba32, in) |*out_pixel, in_pixel| {
        out_pixel.* = .{ .r = in_pixel.r, .g = in_pixel.g, .b = in_pixel.b, .a = 255 };
    }
    return out;
}
