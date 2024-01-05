const std = @import("std");
const mach = @import("mach");
const zigimg = @import("zigimg");
const core = mach.core;
const gpu = mach.gpu;

const Texture = @This();

sampler: *gpu.Sampler,
view: *gpu.TextureView,

pub fn initFromFile(allocator: std.mem.Allocator, path: []const u8) !Texture {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    const data = try file.readToEndAllocOptions(allocator, 1024 * 1024 * 1024, null, @alignOf(u8), 0);
    defer allocator.free(data);

    const ext = std.fs.path.extension(path);
    if (std.mem.eql(u8, ext, ".png")) {
        return initFromPNG(allocator, data);
    }

    return error.UnknownFormat;
}

pub fn initFromPNG(allocator: std.mem.Allocator, data: []const u8) !Texture {
    var img = try zigimg.Image.fromMemory(allocator, data);
    defer img.deinit();

    const img_size = gpu.Extent3D{
        .width = @intCast(img.width),
        .height = @intCast(img.height),
    };

    const texture = core.device.createTexture(&.{
        .size = img_size,
        .format = .rgba8_unorm,
        .usage = .{
            .texture_binding = true,
            .copy_dst = true,
            .render_attachment = true,
        },
    });
    defer texture.release();

    const data_layout = gpu.Texture.DataLayout{
        .bytes_per_row = @as(u32, @intCast(img.width * 4)),
        .rows_per_image = @as(u32, @intCast(img.height)),
    };

    switch (img.pixels) {
        .rgba32 => |pixels| core.queue.writeTexture(&.{ .texture = texture }, &data_layout, &img_size, pixels),
        // .rgb24 => |pixels| {
        //     const rgba32_pixels = try rgb24ToRgba32(allocator, pixels);
        //     defer data.deinit(allocator);
        //     core.queue.writeTexture(&.{ .texture = texture }, &data_layout, &img_size, rgba32_pixels);
        // },
        else => @panic("unsupported image color format"),
    }

    const view = texture.createView(&gpu.TextureView.Descriptor{});
    const sampler = core.device.createSampler(&.{ .mag_filter = .linear, .min_filter = .linear });

    return .{
        .view = view,
        .sampler = sampler,
    };
}

fn rgb24ToRgba32(allocator: std.mem.Allocator, in: []zigimg.color.Rgb24) !zigimg.color.PixelStorage {
    const out = try zigimg.color.PixelStorage.init(allocator, .rgba32, in.len);
    var i: usize = 0;
    while (i < in.len) : (i += 1) {
        out.rgba32[i] = zigimg.color.Rgba32{ .r = in[i].r, .g = in[i].g, .b = in[i].b, .a = 255 };
    }
    return out;
}
