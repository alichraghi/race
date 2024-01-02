const std = @import("std");
const Model = @import("Model.zig");
const mach = @import("mach");
const core = mach.core;
const gpu = mach.gpu;
const math = mach.math;
const Engine = mach.Engine;
const Vec3 = math.Vec3;
const Vec4 = math.Vec4;
const Mat4x4 = math.Mat4x4;
const vec3 = math.vec3;
const vec4 = math.vec4;
const mat4x4 = math.mat4x4;

const Camera = @This();

projection: Mat4x4,
view: Mat4x4,

pub fn init() Camera {
    return .{
        .projection = Mat4x4.ident,
        .view = Mat4x4.ident,
    };
}

fn normalize(v: Vec3) Vec3 {
    return v.mulScalar(1 / v.len());
}

/// Right-handed
pub fn lookAt(camera: *Camera, eye: Vec3, dir: Vec3, up: Vec3) void {
    const f = eye.sub(&dir);
    const s = up.cross(&f);
    const u = f.cross(&s);

    camera.view = mat4x4(
        &vec4(s.x(), u.x(), f.x(), 0),
        &vec4(s.y(), u.y(), f.y(), 0),
        &vec4(s.z(), u.z(), f.z(), 0),
        &vec4(-s.dot(&eye), -u.dot(&eye), -f.dot(&eye), 1),
    ).transpose();
}

pub fn setFreeView(camera: *Camera, position: Vec3, rotation: Vec3) void {
    camera.view = freeView(position, rotation);
}

pub fn freeView(position: Vec3, rotation: Vec3) Mat4x4 {
    const c3 = @cos(rotation.y());
    const s3 = @sin(rotation.y());
    const c2 = @cos(rotation.x());
    const s2 = @sin(rotation.x());
    const c1 = @cos(rotation.z());
    const s1 = @sin(rotation.z());
    const u = vec3((c1 * c3 + s1 * s2 * s3), (c2 * s3), (c1 * s2 * s3 - c3 * s1));
    const v = vec3((c3 * s1 * s2 - c1 * s3), (c2 * c3), (c1 * c3 * s2 + s1 * s3));
    const w = vec3((c2 * s1), (-s2), (c1 * c2));
    return mat4x4(
        &vec4(u.x(), v.x(), w.x(), -u.dot(&position)),
        &vec4(u.y(), v.y(), w.y(), -v.dot(&position)),
        &vec4(u.z(), v.z(), w.z(), w.dot(&position)),
        &vec4(0, 0, 0, 1),
    );
}

// pub fn moveInPlaneXZ(camera: *Camera, x_dir: f32, z_dir: f32, rot_dir: Vec3) !void {
//     var rot = vec3(0, 0, 0);

//     if (rot_dir.dot(&rot_dir) > math.eps_f32) {
//         rot = rot.add(&rot);
//     }

//     const forward_dir = vec3(@sin(rot_dir.y()), 0, @cos(rot_dir.y()));
//     const right_dir = vec3(forward_dir.z(), 0, -forward_dir.x());

//     var move_dir = vec3(0, 0, 0);
//     if (x_dir == 1) {
//         move_dir = move_dir.add(right_dir);
//     } else if (x_dir == -1) {
//         move_dir = move_dir.sub(right_dir);
//     }

//     if (z_dir == 1) {
//         move_dir = move_dir.add(forward_dir);
//     } else if (z_dir == -1) {
//         move_dir = move_dir.sub(forward_dir);
//     }

//     if (move_dir.dot(&move_dir) > math.eps_f32) {
//         camera.setFreeView(move_dir, d);
//     }
// }

/// Right-handed
pub fn perspectiveFovy(camera: *Camera, fovy: f32, aspect: f32, near: f32, far: f32) void {
    const h = 1 / @tan(0.5 * fovy);
    const w = h / aspect;
    const r = far / (near - far);
    camera.projection = mat4x4(
        &vec4(w, 0.0, 0.0, 0.0),
        &vec4(0.0, h, 0.0, 0.0),
        &vec4(0.0, 0.0, r, r * near),
        &vec4(0.0, 0.0, -1, 0.0),
    );
}

pub fn orthographicProjection(
    camera: *Camera,
    left: f32,
    right: f32,
    top: f32,
    bottom: f32,
    near: f32,
    far: f32,
) void {
    camera.projection = mat4x4(
        &vec4(2 / (right - left), 0, 0, 0),
        &vec4(0, 2 / (bottom - top), 0, 0),
        &vec4(0, 0, 1 / (far - near), 0),
        &vec4(-(right + left) / (right - left), -(bottom + top) / (bottom - top), -near / (far - near), 1),
    );
}
