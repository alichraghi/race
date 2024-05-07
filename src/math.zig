const std = @import("std");
const math = @import("mach").math;
const Vec3 = math.Vec3;
const Mat3x3 = math.Mat3x3;
const Mat4x4 = math.Mat4x4;
const vec3 = math.vec3;
const vec4 = math.vec4;
const mat3x3 = math.mat3x3;
const mat4x4 = math.mat4x4;

pub usingnamespace math;

pub const right = vec3(1, 0, 0);
pub const up = vec3(0, 1, 0);
pub const front = vec3(0, 0, 1);

pub fn normalize(v: Vec3) Vec3 {
    return v.mulScalar(1 / v.len());
}

// Local Space to World Space direction
pub fn worldSpaceDirection(local_rotation: Vec3) Vec3 {
    return normalize(vec3(
        @cos(local_rotation.y()) * @cos(local_rotation.x()),
        @sin(local_rotation.x()),
        @sin(local_rotation.y()) * @cos(local_rotation.x()),
    ));
}

pub fn uniformStride(comptime T: type, min_alignment: u32) u32 {
    return ceilToNextMultiple(@sizeOf(T), min_alignment);
}

pub fn ceilToNextMultiple(value: u32, step: u32) u32 {
    const divide_and_ceil = value / step + @as(u32, if (value % step == 0) 0 else 1);
    return step * divide_and_ceil;
}

pub fn transform(translation: Vec3, rotation: Vec3, scale: Vec3) Mat4x4 {
    return Mat4x4.translate(translation)
        .mul(&Mat4x4.rotateZ(rotation.z())
        .mul(&Mat4x4.rotateY(rotation.y()))
        .mul(&Mat4x4.rotateX(rotation.x())))
        .mul(&Mat4x4.scale(scale));
}

pub fn transformNormal(rotation: Vec3, scale: Vec3) Mat3x3 {
    const c3 = @cos(rotation.z());
    const s3 = @sin(rotation.z());
    const c2 = @cos(rotation.x());
    const s2 = @sin(rotation.x());
    const c1 = @cos(rotation.y());
    const s1 = @sin(rotation.y());
    const inv_scale = vec3(1, 1, 1).div(&scale);

    return mat3x3(
        &vec3(
            inv_scale.x() * (c1 * c3 + s1 * s2 * s3),
            inv_scale.x() * (c2 * s3),
            inv_scale.x() * (c1 * s2 * s3 - c3 * s1),
        ),
        &vec3(
            inv_scale.y() * (c3 * s1 * s2 + c1 * s3),
            inv_scale.y() * (c2 * c3),
            inv_scale.y() * (c1 * c3 * s2 - s1 * s3),
        ),
        &vec3(
            inv_scale.z() * (c2 * s1),
            inv_scale.z() * (-s2),
            inv_scale.z() * (c1 * c2),
        ),
    );
}

// pub fn lookAtRh(eyepos: Vec3, focuspos: Vec3, updir: Vec3) Mat4x4 {
//     return lookToLh(eyepos, eyepos.sub(&focuspos), updir);
// }

pub fn lookToLh(eyepos: Vec3, eyedir: Vec3, updir: Vec3) Mat4x4 {
    const az = normalize(eyedir);
    const ax = normalize(updir.cross(&az));
    const ay = normalize(az.cross(&ax));
    return mat4x4(
        &vec4(ax.x(), ax.y(), ax.z(), -ax.dot(&eyepos)),
        &vec4(ay.x(), ay.y(), ay.z(), -ay.dot(&eyepos)),
        &vec4(az.x(), az.y(), az.z(), -az.dot(&eyepos)),
        &vec4(0, 0, 0, 1),
    );
}

pub fn orthoRh(w: f32, h: f32, near: f32, far: f32) Mat4x4 {
    const r = 1 / (near - far);
    return mat4x4(
        &vec4(2 / w, 0, 0, 0),
        &vec4(0, 2 / h, 0, 0),
        &vec4(0, 0, r, r * near),
        &vec4(0, 0, 0, 1),
    ).transpose();
}

// pub fn perspectiveRh(fovy: f32, aspect: f32, near: f32, far: f32) Mat4x4 {
//     std.debug.assert(near > 0 and far > 0);
//     std.debug.assert(!std.math.approxEqAbs(f32, far, near, 0.001));
//     std.debug.assert(!std.math.approxEqAbs(f32, aspect, 0, 0.01));

//     const h = @cos(0.5 * fovy) / @sin(0.5 * fovy);
//     const w = h / aspect;
//     const r = far / (near - far);
//     return mat4x4(
//         &vec4(w, 0, 0, 0),
//         &vec4(0, h, 0, 0),
//         &vec4(0, 0, r, r * near),
//         &vec4(0, 0, -1, 0),
//     );
// }

// old
pub fn perspectiveRh(fovy: f32, aspect: f32, near: f32, far: f32) Mat4x4 {
    const h = 1 / @tan(0.5 * fovy);
    const w = h / aspect;
    const r = far / (near - far);
    return mat4x4(
        &vec4(w, 0.0, 0.0, 0.0),
        &vec4(0.0, h, 0.0, 0.0),
        &vec4(0.0, 0.0, r, r * near),
        &vec4(0.0, 0.0, -1, 0.0),
    );
}

// old
pub fn lookAtRh(eye: Vec3, dir: Vec3, updir: Vec3) Mat4x4 {
    const f = normalize(eye.sub(&dir));
    const s = normalize(updir.cross(&f));
    const u = f.cross(&s);
    return mat4x4(
        &vec4(-s.x(), s.y(), s.z(), -s.dot(&eye)),
        &vec4(-u.x(), u.y(), u.z(), -u.dot(&eye)),
        &vec4(-f.x(), f.y(), f.z(), -f.dot(&eye)),
        &vec4(0, 0, 0, 1),
    );
}
