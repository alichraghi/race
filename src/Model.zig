const std = @import("std");
const mach = @import("mach");
const core = mach.core;
const gpu = core.gpu;

const Model = @This();

vertex_buf: *gpu.Buffer,
vertex_count: u32,

pub fn init(vertices: []const Vertex) Model {
    const vertex_buf = core.device.createBuffer(&.{
        .usage = .{ .vertex = true },
        .size = @sizeOf(Vertex) * vertices.len,
        .mapped_at_creation = .true,
    });
    const vertex_mapped = vertex_buf.getMappedRange(Vertex, 0, vertices.len);
    @memcpy(vertex_mapped.?, vertices[0..]);
    vertex_buf.unmap();
    return .{
        .vertex_buf = vertex_buf,
        .vertex_count = @intCast(vertices.len),
    };
}

pub fn deinit(model: Model) void {
    model.vertex_buf.release();
}

pub fn bind(model: Model, pass: *gpu.RenderPassEncoder) void {
    pass.setVertexBuffer(0, model.vertex_buf, 0, model.vertex_count * @sizeOf(Vertex));
}

pub fn draw(model: Model, pass: *gpu.RenderPassEncoder) void {
    pass.draw(model.vertex_count, 1, 0, 0);
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
