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

const Model = @This();

pub const Mesh = struct {
    material: u32,
    vertex_buf: *gpu.Buffer,
    index_buf: ?*gpu.Buffer,
    vertex_count: u32,
    index_count: u32,
};

pub const Material = struct {
    texture: Texture,
};

meshes: []Mesh,
materials: []Material,

// fn createMesh(vertices: []const shaders.Vertex, indices: ?[]const u32, material: u32) Mesh {
//     // const index_buf, const index_count: u32 = if (indices) |_| blk: {
//     //     const index_buf = core.device.createBuffer(&.{
//     //         .usage = .{ .index = true },
//     //         .size = @sizeOf(u32) * indices.?.len,
//     //         .mapped_at_creation = .true,
//     //     });
//     //     const index_mapped = index_buf.getMappedRange(u32, 0, indices.?.len);
//     //     @memcpy(index_mapped.?, indices.?[0..]);
//     //     index_buf.unmap();
//     //     break :blk .{ index_buf, @intCast(indices.?.len) };
//     // } else .{ null, 0 };

//     return .{
//         .material = material,
//         .vertex_buf = vertex_buf,
//         .vertex_count = @intCast(vertices.len),
//         .index_buf = index_buf,
//         .index_count = index_count,
//     };
// }

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

const M3D_UNDEF: u32 = 0xffffffff; // TODO

const m3dp_Kd: c_int = 0;
const m3dp_Ks: c_int = 2;
const m3dp_Ns: c_int = 3;
const m3dp_Ke: c_int = 4;
const m3dp_Pr: c_int = 64;
const m3dp_Pm: c_int = 65;
const m3dp_Ps: c_int = 66;
const m3dp_map_Kd: c_int = 128;

pub fn initFromM3D(data: [:0]const u8) !Model {
    const m3d = M3d.load(data, null, null, null) orelse return error.LoadModelFailed;
    defer m3d.deinit();

    const mesh_count = @max(m3d.handle.nummaterial, 1);

    var model: Model = .{
        .meshes = try core.allocator.alloc(Mesh, mesh_count),
        .materials = try core.allocator.alloc(Material, mesh_count),
    };

    var l: u32 = 0;
    var k: i32 = -1;
    var mi: i32 = -2;
    for (m3d.handle.face[0..m3d.handle.numface]) |face| {
        if (mi != face.materialid) {
            std.debug.assert(k < mesh_count);
            k += 1;

            mi = @intCast(face.materialid);

            l = 0;
            for (0..m3d.handle.numface) |_| {
                if (mi != face.materialid) break;
                l += 1;
            }

            const material = m3d.materials()[@intCast(mi)];
            for (material.prop[0..material.numprop]) |prop| {
                switch (prop.type) {
                    m3dp_Kd => {
                        // memcpy(&model.materials[i + 1].maps[MATERIAL_MAP_DIFFUSE].color, &prop.value.color, 4);
                        // model.materials[i + 1].maps[MATERIAL_MAP_DIFFUSE].value = 0.0f;
                    },
                    m3dp_Ks => {
                        // memcpy(&model.materials[i + 1].maps[MATERIAL_MAP_SPECULAR].color, &prop.value.color, 4);
                    },
                    m3dp_Ns => {
                        // model.materials[i + 1].maps[MATERIAL_MAP_SPECULAR].value = prop.value.fnum;
                    },
                    m3dp_Ke => {
                        // memcpy(&model.materials[i + 1].maps[MATERIAL_MAP_EMISSION].color, &prop.value.color, 4);
                        // model.materials[i + 1].maps[MATERIAL_MAP_EMISSION].value = 0.0f;
                    },
                    m3dp_Pm => {
                        // model.materials[i + 1].maps[MATERIAL_MAP_METALNESS].value = prop.value.fnum;
                    },
                    m3dp_Pr => {
                        // model.materials[i + 1].maps[MATERIAL_MAP_ROUGHNESS].value = prop.value.fnum;
                    },
                    m3dp_Ps => {
                        // model.materials[i + 1].maps[MATERIAL_MAP_NORMAL].color = WHITE;
                        // model.materials[i + 1].maps[MATERIAL_MAP_NORMAL].value = prop.value.fnum;
                    },
                    m3dp_map_Kd => {
                        const texture = m3d.textures()[prop.value.textureid];
                        // TODO: grayscale texture
                        if (texture.f != 1) {
                            const size = @as(u32, @intCast(texture.w)) * texture.h * texture.f;
                            model.materials[@intCast(mi)] = .{
                                .texture = try Texture.init(
                                    texture.w,
                                    texture.h,
                                    switch (texture.f) {
                                        4 => .rgba,
                                        3 => .rgb,
                                        else => unreachable,
                                    },
                                    texture.d[0..size],
                                ),
                            };
                        } else {
                            // TODO: cache this
                            model.materials[@intCast(mi)] = .{
                                .texture = Texture.initFromFile("assets/missing.png") catch unreachable,
                            };
                        }
                    },
                    else => {
                        if (prop.type >= 128) {
                            // const texture = m3d.textures()[prop.value.textureid];
                            // model.materials[i] = .{
                            //     .texture = try Texture.init(
                            //         texture.w,
                            //         texture.h,
                            //         switch (texture.f) {
                            //             4 => .rgba,
                            //             3 => .rgb,
                            //             else => std.debug.panic("\n{}, {}, {}\n", .{ texture.w, texture.h, texture.f }),
                            //         },
                            //         texture.d[0 .. texture.w * texture.h * texture.f],
                            //     ),
                            // };

                            // switch (prop.type)
                            // {
                            //     case m3dp_map_Kd: model.materials[i + 1].maps[MATERIAL_MAP_DIFFUSE].texture = LoadTextureFromImage(image); break;
                            //     case m3dp_map_Ks: model.materials[i + 1].maps[MATERIAL_MAP_SPECULAR].texture = LoadTextureFromImage(image); break;
                            //     case m3dp_map_Ke: model.materials[i + 1].maps[MATERIAL_MAP_EMISSION].texture = LoadTextureFromImage(image); break;
                            //     case m3dp_map_Km: model.materials[i + 1].maps[MATERIAL_MAP_NORMAL].texture = LoadTextureFromImage(image); break;
                            //     case m3dp_map_Ka: model.materials[i + 1].maps[MATERIAL_MAP_OCCLUSION].texture = LoadTextureFromImage(image); break;
                            //     case m3dp_map_Pm: model.materials[i + 1].maps[MATERIAL_MAP_ROUGHNESS].texture = LoadTextureFromImage(image); break;
                            //     default: break;
                            // }
                        }
                    },
                }
            }

            const vertex_count = l * 3;
            model.meshes[@intCast(k)] = .{
                .material = @intCast(mi),
                .vertex_buf = core.device.createBuffer(&.{
                    .usage = .{ .vertex = true },
                    .size = @sizeOf(shaders.Vertex) * vertex_count,
                    .mapped_at_creation = .true,
                }),
                .index_buf = null,
                .vertex_count = vertex_count,
                .index_count = 0,
            };
            l = 0;
        }

        // Process meshes per material, add triangles

        const vertex = model.meshes[@intCast(k)].vertex_buf.getMappedRange(shaders.Vertex, @sizeOf(shaders.Vertex) * l * 3, 3).?;
        vertex[0].position = vec3(
            m3d.handle.vertex[face.vertex[0]].x,
            m3d.handle.vertex[face.vertex[0]].y,
            m3d.handle.vertex[face.vertex[0]].z,
        ).mulScalar(m3d.scale());
        vertex[1].position = vec3(
            m3d.handle.vertex[face.vertex[1]].x,
            m3d.handle.vertex[face.vertex[1]].y,
            m3d.handle.vertex[face.vertex[1]].z,
        ).mulScalar(m3d.scale());
        vertex[2].position = vec3(
            m3d.handle.vertex[face.vertex[2]].x,
            m3d.handle.vertex[face.vertex[2]].y,
            m3d.handle.vertex[face.vertex[2]].z,
        ).mulScalar(m3d.scale());

        if (face.texcoord[0] != M3D_UNDEF) {
            for (0..3) |i| {
                if (m3d.handle.tmap != null and face.texcoord[i] < m3d.handle.numtmap) {
                    vertex[i].uv = vec2(m3d.handle.tmap[face.texcoord[i]].u, 1 - m3d.handle.tmap[face.texcoord[i]].v);
                } else {
                    vertex[i].uv = vec2(0, 0);
                }
            }
        }

        if (face.normal[0] != M3D_UNDEF) {
            vertex[0].normal = vec3(m3d.handle.vertex[face.normal[0]].x, m3d.handle.vertex[face.normal[0]].y, m3d.handle.vertex[face.normal[0]].z);
            vertex[1].normal = vec3(m3d.handle.vertex[face.normal[0]].x, m3d.handle.vertex[face.normal[0]].y, m3d.handle.vertex[face.normal[0]].z);
            vertex[2].normal = vec3(m3d.handle.vertex[face.normal[0]].x, m3d.handle.vertex[face.normal[0]].y, m3d.handle.vertex[face.normal[0]].z);
        }

        l += 1;
    }

    // Load materials
    // for (m3d.materials(), 0..) |material, i| {

    // }

    for (model.meshes) |mesh| {
        mesh.vertex_buf.unmap();
        if (mesh.index_buf) |index_buf| index_buf.unmap();
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

    for (model.materials) |material| {
        material.texture.release();
    }

    core.allocator.free(model.meshes);
    core.allocator.free(model.materials);
}
