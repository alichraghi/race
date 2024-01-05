const std = @import("std");
const mach = @import("mach");
const M3d = @import("model3d");
const math = @import("math.zig");
const core = mach.core;
const gpu = core.gpu;
const Vec3 = math.Vec3;
const Vec2 = math.Vec2;
const vec2 = math.vec2;
const vec3 = math.vec3;

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

pub fn initFromFile(allocator: std.mem.Allocator, path: []const u8) !Model {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    const data = try file.readToEndAllocOptions(allocator, 1024 * 1024 * 1024, null, @alignOf(u8), 0);
    defer allocator.free(data);

    const ext = std.fs.path.extension(path);
    if (std.mem.eql(u8, ext, ".m3d")) {
        return initFromM3D(allocator, data);
    }

    return error.UnknownFormat;
}

pub fn initFromM3D(allocator: std.mem.Allocator, data: [:0]const u8) !Model {
    const m3d_model = M3d.load(data, null, null, null) orelse return error.LoadModelFailed;

    const vertex_count = m3d_model.handle.numvertex;
    const face_count = m3d_model.handle.numface;
    const index_count = face_count * 3;
    const vertices = m3d_model.handle.vertex[0..vertex_count];

    var vertex_writer = try mach.gfx.util.VertexWriter(Vertex, u32).init(
        allocator,
        @intCast(index_count),
        @intCast(vertex_count),
        @intCast(face_count * 3),
    );
    defer vertex_writer.deinit(allocator);

    var extent_min = Vec2.splat(std.math.floatMax(f32));
    var extent_max = Vec2.splat(std.math.floatMin(f32));

    for (0..face_count) |i| {
        const face = m3d_model.handle.face[i];
        for (0..3) |x| {
            const vertex_index = face.vertex[x];
            const normal_index = face.normal[x];
            const position = vec3(
                vertices[vertex_index].x,
                vertices[vertex_index].y,
                vertices[vertex_index].z,
            );
            extent_min = vec2(
                @min(position.x(), extent_min.x()),
                @min(position.y(), extent_min.y()),
            );
            extent_max = vec2(
                @max(position.x(), extent_max.x()),
                @max(position.y(), extent_max.y()),
            );

            const vertex = Vertex{
                .position = position,
                .normal = vec3(
                    vertices[normal_index].x,
                    vertices[normal_index].y,
                    vertices[normal_index].z,
                ),
                .uv = vec2(position.x(), position.y()),
            };
            vertex_writer.put(vertex, vertex_index);
        }
    }

    const vertex_buffer = vertex_writer.vertices[0..vertex_writer.next_packed_index];
    const index_buffer = vertex_writer.indices;

    for (vertex_buffer) |*vertex| {
        vertex.uv = vertex.uv.sub(&extent_min).div(&extent_max.sub(&extent_min));
    }

    return init(vertex_buffer, index_buffer);
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
    position: Vec3,
    color: Vec3 = vec3(1, 1, 1), // TODO
    normal: Vec3 = vec3(0, 0, 0), // TODO
    uv: Vec2 = vec2(0, 0), // TODO

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
        .{
            .format = .float32x3,
            .offset = @offsetOf(Vertex, "normal"),
            .shader_location = 2,
        },
        .{
            .format = .float32x2,
            .offset = @offsetOf(Vertex, "uv"),
            .shader_location = 3,
        },
    };

    pub const layout = gpu.VertexBufferLayout.init(.{
        .array_stride = @sizeOf(Vertex),
        .step_mode = .vertex,
        .attributes = &attributes,
    });
};
