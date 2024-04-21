const std = @import("std");
const mach = @import("mach");
const M3d = @import("model3d");
const wavefront = @import("wavefront.zig");
const c = @cImport(@cInclude("ufbx.h"));
const math = @import("math.zig");
const core = mach.core;
const gpu = mach.gpu;
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

pub fn initFromFile(path: []const u8) !Model {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    const data = try file.readToEndAllocOptions(core.allocator, 1024 * 1024 * 1024, null, @alignOf(u8), 0);
    defer core.allocator.free(data);

    const ext = std.fs.path.extension(path);
    if (std.mem.eql(u8, ext, ".m3d")) {
        return initFromM3D(data);
    } else if (std.mem.eql(u8, ext, ".obj")) {
        return initFromWavefront(data);
    } else if (std.mem.eql(u8, ext, ".fbx")) {
        return initFromFBX(data);
    }

    return error.UnknownFormat;
}

pub fn initFromWavefront(data: []const u8) !Model {
    var fbs = std.io.fixedBufferStream(data);
    var model = try wavefront.load(core.allocator, fbs.reader());
    defer model.deinit();

    var vertices = std.ArrayList(Vertex).init(core.allocator);
    defer vertices.deinit();

    var indices = std.ArrayList(u32).init(core.allocator);
    defer indices.deinit();

    for (model.faces) |face| {
        std.debug.assert(face.vertices.len == 3);

        for (face.vertices) |src_vtx| {
            const position = model.positions[src_vtx.position];
            const normal = if (src_vtx.normal) |i| model.normals[i] else vec3(0, 0, 0);
            const uv = if (src_vtx.uv) |i| model.uvs[i] else vec3(0, 0, 0);
            const dst_vertex = Vertex{
                .position = vec3(position.x(), position.y(), position.z()),
                .normal = normal,
                .uv = vec2(uv.x(), uv.y()),
            };
            const index: u32 = @intCast(vertices.items.len);
            try vertices.append(dst_vertex);
            try indices.append(index);
        }
    }

    return init(vertices.items, indices.items);
}

pub fn initFromFBX(data: []const u8) !Model {
    var err: c.ufbx_error = .{};
    const opts = c.ufbx_load_opts{
        .target_axes = .{
            .right = c.UFBX_COORDINATE_AXIS_NEGATIVE_X,
            .up = c.UFBX_COORDINATE_AXIS_POSITIVE_Y,
            .front = c.UFBX_COORDINATE_AXIS_POSITIVE_Z,
        },
    };
    const scene = c.ufbx_load_memory(data.ptr, data.len, &opts, &err);
    if (err.type != c.UFBX_ERROR_NONE) return error.LoadingModel;
    defer c.ufbx_free_scene(scene);

    // We only support one mesh per file
    const meshes = scene.*.unnamed_0.unnamed_0.meshes;
    const mesh = meshes.data[0..meshes.count][0];

    // Count the number of needed parts and temporary buffers
    var max_parts: usize = 0;
    var max_triangles: usize = 0;

    // We need to render each material of the mesh in a separate part, so let's
    // count the number of parts and maximum number of triangles needed.
    for (mesh.*.material_parts.data[0..mesh.*.material_parts.count]) |part| {
        if (part.num_triangles == 0) continue;
        max_parts += 1;
        max_triangles = @max(max_triangles, part.num_triangles);
    }

    const tri_indices = try core.allocator.alloc(u32, mesh.*.max_face_triangles * 3);
    defer core.allocator.free(tri_indices);
    const vertices = try core.allocator.alloc(Vertex, max_triangles * 3);
    defer core.allocator.free(vertices);
    const indices = try core.allocator.alloc(u32, max_triangles * 3);
    defer core.allocator.free(indices);

    var num_indices: u32 = 0;
    for (mesh.*.faces.data[0..mesh.*.faces.count]) |face| {
        const num_tris = c.ufbx_triangulate_face(tri_indices.ptr, tri_indices.len, mesh, face);

        for (0..num_tris * 3) |vi| {
            const ix = tri_indices[vi];

            const pos = c.ufbx_get_vertex_vec3(&mesh.*.vertex_position, ix);
            const normal = c.ufbx_get_vertex_vec3(&mesh.*.vertex_normal, ix);
            const uv = if (mesh.*.vertex_uv.exists) c.ufbx_get_vertex_vec2(&mesh.*.vertex_uv, ix) else c.ufbx_vec2{};

            vertices[num_indices] = .{
                .position = vec3(
                    @floatCast(pos.unnamed_0.unnamed_0.x),
                    @floatCast(pos.unnamed_0.unnamed_0.y),
                    @floatCast(pos.unnamed_0.unnamed_0.z),
                ),
                .normal = vec3(
                    @floatCast(normal.unnamed_0.unnamed_0.x),
                    @floatCast(normal.unnamed_0.unnamed_0.y),
                    @floatCast(normal.unnamed_0.unnamed_0.z),
                ),
                .uv = vec2(
                    @floatCast(uv.unnamed_0.unnamed_0.x),
                    @floatCast(uv.unnamed_0.unnamed_0.y),
                ),
            };

            num_indices += 1;
        }
    }

    var streams: [1]c.ufbx_vertex_stream = .{.{
        .data = vertices.ptr,
        .vertex_count = num_indices,
        .vertex_size = @sizeOf(Vertex),
    }};

    const num_vertices = c.ufbx_generate_indices(&streams, streams.len, indices.ptr, num_indices, null, &err);
    if (err.type != c.UFBX_ERROR_NONE) {
        return error.LoadingModel;
    }

    return init(vertices[0..num_vertices], indices[0..num_indices]);
}

pub fn initFromM3D(data: [:0]const u8) !Model {
    const m3d_model = M3d.load(data, null, null, null) orelse return error.LoadModelFailed;

    const vertex_count = m3d_model.handle.numvertex;
    const face_count = m3d_model.handle.numface;
    const index_count = face_count * 3;
    const vertices = m3d_model.handle.vertex[0..vertex_count];

    var vertex_writer = try mach.gfx.util.VertexWriter(Vertex, u32).init(
        core.allocator,
        @intCast(index_count),
        @intCast(vertex_count),
        @intCast(face_count * 3),
    );
    defer vertex_writer.deinit(core.allocator);

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

// TODO: move to shaders.zig
pub const Vertex = struct {
    position: Vec3,
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
            .offset = @offsetOf(Vertex, "normal"),
            .shader_location = 1,
        },
        .{
            .format = .float32x2,
            .offset = @offsetOf(Vertex, "uv"),
            .shader_location = 2,
        },
    };

    pub const layout = gpu.VertexBufferLayout.init(.{
        .array_stride = @sizeOf(Vertex),
        .step_mode = .vertex,
        .attributes = &attributes,
    });
};
