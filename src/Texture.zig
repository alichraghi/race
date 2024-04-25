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
    return initFromImage(data);
}

const Format = enum {
    rgb,
    rgba,
};

pub fn init(width: u32, height: u32, format: Format, pixels: []const u8) !Texture {
    const size = gpu.Extent3D{ .width = width, .height = height };
    const data_layout = gpu.Texture.DataLayout{ .bytes_per_row = width * 4, .rows_per_image = height };

    const texture = core.device.createTexture(&.{
        .size = size,
        .format = .rgba8_unorm,
        .usage = .{
            // TODO
            .texture_binding = true,
            .copy_dst = true,
            .render_attachment = true,
        },
    });
    defer texture.release();

    switch (format) {
        .rgba => core.queue.writeTexture(&.{ .texture = texture }, &data_layout, &size, pixels),
        .rgb => {
            const rgb_pixels = @as([*]const [3]u8, @ptrCast(pixels))[0 .. pixels.len / 3];
            const rgba_pixels = try rgbToRgba(rgb_pixels);
            core.queue.writeTexture(&.{ .texture = texture }, &data_layout, &size, rgba_pixels);
        },
    }

    const sampler = core.device.createSampler(&.{ .mag_filter = .linear, .min_filter = .linear });
    const view = texture.createView(&gpu.TextureView.Descriptor{});

    return .{
        .sampler = sampler,
        .view = view,
    };
}

pub fn initFromImage(data: []const u8) !Texture {
    var img = try zigimg.Image.fromMemory(core.allocator, data);
    defer img.deinit();
    const format: Format = switch (img.pixelFormat()) {
        .rgb24 => .rgb,
        .rgba32 => .rgba,
        else => return error.UnsupportedPixelFormat,
    };
    return init(@intCast(img.width), @intCast(img.height), format, img.pixels.asBytes());
}

fn rgbToRgba(src: []const [3]u8) ![][4]u8 {
    const out = try core.allocator.alloc([4]u8, src.len);
    for (out, src) |*out_pixel, src_pixel| {
        out_pixel[0..4].* = .{ src_pixel[0], src_pixel[1], src_pixel[2], 255 };
    }
    return out;
}
