const std = @import("std");
const mach = @import("mach");
const M3d = @import("model3d");
const math = @import("math.zig");
const core = mach.core;
const gpu = core.gpu;
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

pub fn initFromM3D(allocator: std.mem.Allocator, data: [:0]const u8) !Model {
    const m3d_model = M3d.load(data, null, null, null) orelse return error.LoadModelFailed;

    const vertex_count = m3d_model.handle.numvertex;
    const vertices = m3d_model.handle.vertex[0..vertex_count];

    const face_count = m3d_model.handle.numface;
    const index_count = (face_count * 3) + 6;

    var vertex_writer = try VertexWriter(Vertex, u32).init(
        allocator,
        @intCast(index_count),
        @intCast(vertex_count),
        @intCast(face_count * 3),
    );
    defer vertex_writer.deinit(allocator);

    const scale: f32 = 80.0;
    const plane_xy = [2]usize{ 0, 1 };
    var extent_min = [2]f32{ std.math.floatMax(f32), std.math.floatMax(f32) };
    var extent_max = [2]f32{ std.math.floatMin(f32), std.math.floatMin(f32) };

    var i: usize = 0;
    while (i < face_count) : (i += 1) {
        const face = m3d_model.handle.face[i];
        var x: usize = 0;
        while (x < 3) : (x += 1) {
            const vertex_index = face.vertex[x];
            const normal_index = face.normal[x];
            const position = vec3(
                vertices[vertex_index].x * scale,
                vertices[vertex_index].y * scale,
                vertices[vertex_index].z * scale,
            );
            extent_min[0] = @min(position.v[plane_xy[0]], extent_min[0]);
            extent_min[1] = @min(position.v[plane_xy[1]], extent_min[1]);
            extent_max[0] = @max(position.v[plane_xy[0]], extent_max[0]);
            extent_max[1] = @max(position.v[plane_xy[1]], extent_max[1]);

            const vertex = Vertex{
                .position = position.v,
                .normal = .{
                    vertices[normal_index].x,
                    vertices[normal_index].y,
                    vertices[normal_index].z,
                },
                .uv = .{ position.v[plane_xy[0]], position.v[plane_xy[1]] },
            };
            vertex_writer.put(vertex, vertex_index);
        }
    }

    const vertex_buffer = vertex_writer.vertices[0 .. vertex_writer.next_packed_index + 4];
    const index_buffer = vertex_writer.indices;

    //
    // Compute UV values
    //
    for (vertex_buffer) |*vertex| {
        vertex.uv = .{
            (vertex.uv[0] - extent_min[0]) / (extent_max[0] - extent_min[0]),
            (vertex.uv[1] - extent_min[1]) / (extent_max[1] - extent_min[1]),
        };
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
    position: @Vector(3, f32),
    color: @Vector(3, f32) = .{ 1, 0.2, 0.2 },
    normal: @Vector(3, f32) = undefined, // TODO
    uv: @Vector(2, f32) = undefined, // TODO

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

/// Vertex writer manages the placement of vertices by tracking which are unique. If a duplicate vertex is added
/// with `put`, only it's index will be written to the index buffer.
/// `IndexType` should match the integer type used for the index buffer
pub fn VertexWriter(comptime VertexType: type, comptime IndexType: type) type {
    return struct {
        const MapEntry = struct {
            packed_index: IndexType = null_index,
            next_sparse: IndexType = null_index,
        };

        const null_index: IndexType = std.math.maxInt(IndexType);

        vertices: []VertexType,
        indices: []IndexType,
        sparse_to_packed_map: []MapEntry,

        /// Next index outside of the 1:1 mapping range for storing
        /// position -> normal collisions
        next_collision_index: IndexType,

        /// Next packed index
        next_packed_index: IndexType,
        written_indices_count: IndexType,

        /// Allocate storage and set default values
        /// `sparse_vertices_count` is the number of vertices in the source before de-duplication / remapping
        /// Put more succinctly, the largest index value in source index buffer
        /// `max_vertex_count` is largest permutation of vertices assuming that {vertex, uv, normal} never map 1:1 and always
        /// create a new mapping
        pub fn init(
            allocator: std.mem.Allocator,
            indices_count: IndexType,
            sparse_vertices_count: IndexType,
            max_vertex_count: IndexType,
        ) !@This() {
            var result: @This() = undefined;
            result.vertices = try allocator.alloc(VertexType, max_vertex_count);
            result.indices = try allocator.alloc(IndexType, indices_count);
            result.sparse_to_packed_map = try allocator.alloc(MapEntry, max_vertex_count);
            result.next_collision_index = sparse_vertices_count;
            result.next_packed_index = 0;
            result.written_indices_count = 0;
            @memset(result.sparse_to_packed_map, .{});
            return result;
        }

        pub fn put(self: *@This(), vertex: VertexType, sparse_index: IndexType) void {
            if (self.sparse_to_packed_map[sparse_index].packed_index == null_index) {
                // New start of chain, reserve a new packed index and add entry to `index_map`
                const packed_index = self.next_packed_index;
                self.sparse_to_packed_map[sparse_index].packed_index = packed_index;
                self.vertices[packed_index] = vertex;
                self.indices[self.written_indices_count] = packed_index;
                self.written_indices_count += 1;
                self.next_packed_index += 1;
                return;
            }
            var previous_sparse_index: IndexType = undefined;
            var current_sparse_index = sparse_index;
            while (current_sparse_index != null_index) {
                const packed_index = self.sparse_to_packed_map[current_sparse_index].packed_index;
                if (std.mem.eql(u8, &std.mem.toBytes(self.vertices[packed_index]), &std.mem.toBytes(vertex))) {
                    // We already have a record for this vertex in our chain
                    self.indices[self.written_indices_count] = packed_index;
                    self.written_indices_count += 1;
                    return;
                }
                previous_sparse_index = current_sparse_index;
                current_sparse_index = self.sparse_to_packed_map[current_sparse_index].next_sparse;
            }
            // This is a new mapping for the given sparse index
            const packed_index = self.next_packed_index;
            const remapped_sparse_index = self.next_collision_index;
            self.indices[self.written_indices_count] = packed_index;
            self.vertices[packed_index] = vertex;
            self.sparse_to_packed_map[previous_sparse_index].next_sparse = remapped_sparse_index;
            self.sparse_to_packed_map[remapped_sparse_index].packed_index = packed_index;
            self.next_packed_index += 1;
            self.next_collision_index += 1;
            self.written_indices_count += 1;
        }

        pub fn deinit(self: *@This(), allocator: std.mem.Allocator) void {
            allocator.free(self.vertices);
            allocator.free(self.indices);
            allocator.free(self.sparse_to_packed_map);
        }

        pub fn indexBuffer(self: @This()) []IndexType {
            return self.indices;
        }

        pub fn vertexBuffer(self: @This()) []VertexType {
            return self.vertices[0..self.next_packed_index];
        }
    };
}
