const std = @import("std");
const mach = @import("mach");
const core = mach.core;
const gpu = core.gpu;

const Model = @This();

vertex_buf: *gpu.Buffer,
vertex_count: u32,

index_buf: ?*gpu.Buffer,
index_count: u32,

pub fn init(vertices: []const Vertex, indices: ?[]const u32) Model {
    const vertex_buf = core.device.createBuffer(&.{
        .usage = .{ .vertex = true },
        .size = @sizeOf(Vertex) * vertices.len,
        .mapped_at_creation = .true,
    });
    const vertex_mapped = vertex_buf.getMappedRange(Vertex, 0, vertices.len);
    @memcpy(vertex_mapped.?, vertices[0..]);
    vertex_buf.unmap();

    const index_buf, const index_count: u32 = if (indices) |_| blk: {
        const index_buf = core.device.createBuffer(&.{
            .usage = .{ .index = true },
            .size = @sizeOf(u32) * indices.?.len,
            .mapped_at_creation = .true,
        });
        const index_mapped = index_buf.getMappedRange(u32, 0, indices.?.len);
        @memcpy(index_mapped.?, indices.?[0..]);
        index_buf.unmap();
        break :blk .{ index_buf, @intCast(indices.?.len) };
    } else .{ null, 0 };

    return .{
        .vertex_buf = vertex_buf,
        .vertex_count = @intCast(vertices.len),
        .index_buf = index_buf,
        .index_count = index_count,
    };
}

pub fn deinit(model: Model) void {
    model.vertex_buf.release();
    if (model.index_buf) |index_buf| {
        index_buf.release();
    }
}

pub fn bind(model: Model, pass: *gpu.RenderPassEncoder) void {
    pass.setVertexBuffer(0, model.vertex_buf, 0, model.vertex_count * @sizeOf(Vertex));
    if (model.index_buf) |index_buf| {
        pass.setIndexBuffer(index_buf, .uint32, 0, model.index_count * @sizeOf(u32));
    }
}

pub fn draw(model: Model, pass: *gpu.RenderPassEncoder) void {
    if (model.index_buf) |_| {
        pass.drawIndexed(model.index_count, 1, 0, 0, 0);
    } else {
        pass.draw(model.vertex_count, 1, 0, 0);
    }
}

pub const Vertex = struct {
    position: @Vector(3, f32),
    color: @Vector(3, f32) = .{ 0, 0, 0 },

    pub const attributes = [_]gpu.VertexAttribute{
        .{
            .format = .float32x3,
            .offset = @offsetOf(Vertex, "position"),
            .shader_location = 0,
        },
        .{
            .format = .float32x3,
            .offset = @offsetOf(Vertex, "color"),
            .shader_location = 1,
        },
    };

    pub const layout = gpu.VertexBufferLayout.init(.{
        .array_stride = @sizeOf(Vertex),
        .step_mode = .vertex,
        .attributes = &attributes,
    });
};
