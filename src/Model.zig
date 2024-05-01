const std = @import("std");
const mach = @import("mach");
const M3d = @import("model3d");
const wavefront = @import("wavefront.zig");
const math = @import("math.zig");
const Texture = @import("Texture.zig");
const shaders = @import("shaders.zig");
const core = mach.core;
const gpu = mach.gpu;
const Vec4 = math.Vec4;
const Vec3 = math.Vec3;
const Vec2 = math.Vec2;
const vec2 = math.vec2;
const vec3 = math.vec3;
const vec4 = math.vec4;

const Model = @This();

pub const Mesh = struct {
    material: ?u32,
    vertex_buf: *gpu.Buffer,
    index_buf: ?*gpu.Buffer,
    vertex_count: u32,
    index_count: u32,
};

pub const Material = struct {
    name: []const u8,
    texture: Texture,
    normal: ?Texture = null,
    metallic: f32 = 0,
    roughness: f32 = 0,

    pub fn deinit(material: Material) void {
        material.texture.deinit();
        if (material.normal) |normal| normal.deinit();
    }
};

name: []const u8,
meshes: []Mesh,
materials: []Material,

pub fn initFromFile(path: []const u8) !Model {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    const data = try file.readToEndAllocOptions(core.allocator, 1024 * 1024 * 1024, null, @alignOf(u8), 0);
    defer core.allocator.free(data);

    const ext = std.fs.path.extension(path);
    if (std.mem.eql(u8, ext, ".m3d")) {
        return initFromM3D(data);
    }

    return error.UnknownFormat;
}

// TODO
const M3D_UNDEF: u32 = 0xFFFFFFFF;
const m3dp_Ks: c_int = 2;
const m3dp_Pr: c_int = 64;
const m3dp_Pm: c_int = 65;
const m3dp_map_Kd: c_int = 128;
const m3dp_map_Km: c_int = 134;

pub fn initFromM3D(data: [:0]const u8) !Model {
    const m3d = M3d.load(data, null, null, null) orelse return error.LoadModelFailed;
    defer m3d.deinit();

    // Count Meshes
    var mesh_count: u32 = 0;
    var last_material = @as(u32, 0) -% 2;
    for (m3d.handle.face[0..m3d.handle.numface]) |face| {
        if (last_material != face.materialid) {
            last_material = face.materialid;
            mesh_count += 1;
        }
    }

    // Allocate Meshes/Materials
    var model: Model = .{
        .name = std.mem.span(m3d.handle.name),
        .meshes = try core.allocator.alloc(Mesh, mesh_count),
        .materials = try core.allocator.alloc(Material, m3d.handle.nummaterial),
    };

    var face_index: u32 = 0;
    for (model.meshes[0..mesh_count]) |*mesh| {
        // Count Mesh faces
        var face_count: u32 = 0;
        last_material = m3d.handle.face[face_index].materialid;
        for (m3d.handle.face[face_index..m3d.handle.numface]) |face| {
            if (last_material != face.materialid) break;
            face_count += 1;
        }
        const vertex_count = face_count * 3;

        // Load Vertex attributes
        const vertex_buf = core.device.createBuffer(&.{
            .usage = .{ .vertex = true },
            .size = @sizeOf(shaders.Vertex) * vertex_count,
            .mapped_at_creation = .true,
        });
        for (m3d.handle.face[face_index..][0..face_count], 0..) |face, i| {
            const vertices: []shaders.Vertex = vertex_buf.getMappedRange(
                shaders.Vertex,
                @sizeOf(shaders.Vertex) * i * 3,
                3,
            ).?;

            for (vertices, face.vertex, face.normal, face.texcoord) |*vertex, position, normal, uv| {
                vertex.position = vec3(
                    m3d.handle.vertex[position].x,
                    m3d.handle.vertex[position].y,
                    m3d.handle.vertex[position].z,
                ).mulScalar(m3d.scale());

                if (face.normal[0] != M3D_UNDEF) {
                    vertex.normal = vec3(
                        m3d.handle.vertex[normal].x,
                        m3d.handle.vertex[normal].y,
                        m3d.handle.vertex[normal].z,
                    );
                } else {
                    // TODO: default_normal_value constant
                    vertex.normal = vec3(0.5, 0.5, 1);
                }

                if (face.texcoord[0] != M3D_UNDEF) {
                    if (m3d.handle.tmap != null and uv < m3d.handle.numtmap) {
                        vertex.uv = vec2(m3d.handle.tmap[uv].u, 1 - m3d.handle.tmap[uv].v);
                    } else {
                        vertex.uv = vec2(0, 0);
                    }
                } else {
                    vertex.uv = vec2(0, 0);
                }
            }

            // Calculate Tangets
            for (vertices) |*v| {
                const x1 = vertices[1].position.x() - vertices[0].position.x();
                const y1 = vertices[1].position.y() - vertices[0].position.y();
                const z1 = vertices[1].position.z() - vertices[0].position.z();
                const x2 = vertices[2].position.x() - vertices[0].position.x();
                const y2 = vertices[2].position.y() - vertices[0].position.y();
                const z2 = vertices[2].position.z() - vertices[0].position.z();

                const s1 = vertices[1].uv.x() - vertices[0].uv.x();
                const t1 = vertices[1].uv.y() - vertices[0].uv.y();
                const s2 = vertices[2].uv.x() - vertices[0].uv.x();
                const t2 = vertices[2].uv.y() - vertices[0].uv.y();

                const div = s1 * t2 - s2 * t1;
                const r = if (div == 0) 0 else 1 / div;

                const sdir = vec3((t2 * x1 - t1 * x2) * r, (t2 * y1 - t1 * y2) * r, (t2 * z1 - t1 * z2) * r);
                const tdir = vec3((s1 * x2 - s2 * x1) * r, (s1 * y2 - s2 * y1) * r, (s1 * z2 - s2 * z1) * r);

                const tangent = v.normal.normalize(0).cross(&sdir).normalize(0).cross(&v.normal);
                v.tangent = vec4(
                    tangent.x(),
                    tangent.y(),
                    tangent.z(),
                    if (v.normal.cross(&tangent).dot(&tdir) < 0) -1 else 1,
                );
            }
        }

        // Load Material
        const material_id = m3d.handle.face[face_index].materialid;
        if (material_id != M3D_UNDEF) {
            const material = m3d.handle.material[material_id];
            model.materials[material_id] = .{
                .name = std.mem.span(material.name),
                .texture = undefined,
            };

            for (material.prop[0..material.numprop]) |prop| {
                switch (prop.type) {
                    m3dp_Pm => model.materials[material_id].metallic = prop.value.fnum,
                    m3dp_Pr => model.materials[material_id].roughness = prop.value.fnum,
                    m3dp_map_Kd, m3dp_map_Km => {
                        const m3d_texture = m3d.textures()[prop.value.textureid];
                        const size = @as(u32, @intCast(m3d_texture.w)) * m3d_texture.h * m3d_texture.f;
                        const texture = try Texture.init(
                            m3d_texture.w,
                            m3d_texture.h,
                            switch (m3d_texture.f) {
                                4 => .rgba,
                                3 => .rgb,
                                else => unreachable,
                            },
                            m3d_texture.d[0..size],
                        );

                        switch (prop.type) {
                            m3dp_map_Kd => model.materials[material_id].texture = texture,
                            m3dp_map_Km => model.materials[material_id].normal = texture,
                            else => unreachable,
                        }
                    },
                    else => {},
                }
            }
        }

        // Finalize Mesh
        vertex_buf.unmap();
        mesh.* = .{
            .material = if (material_id == M3D_UNDEF) null else material_id,
            .vertex_buf = vertex_buf,
            .index_buf = null,
            .vertex_count = vertex_count,
            .index_count = 0,
        };
        face_index += face_count;
    }

    return model;
}

pub fn deinit(model: Model) void {
    for (model.meshes) |mesh| {
        mesh.vertex_buf.release();
        if (mesh.index_buf) |index_buf| {
            index_buf.release();
        }
    }

    for (model.materials) |material| material.deinit();

    core.allocator.free(model.meshes);
    core.allocator.free(model.materials);
}
