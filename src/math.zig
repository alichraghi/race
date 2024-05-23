const std = @import("std");
const math = @import("mach").math;
const Vec3 = math.Vec3;
const Vec4 = math.Vec4;
const Mat3x3 = math.Mat3x3;
const Mat4x4 = math.Mat4x4;
const vec3 = math.vec3;
const vec4 = math.vec4;
const mat3x3 = math.mat3x3;
const mat4x4 = math.mat4x4;

pub usingnamespace math;

pub const RIGHT = vec3(1, 0, 0);
pub const UP = vec3(0, 1, 0);
pub const FRONT = vec3(0, 0, 1);

pub fn normalize(v: Vec3) Vec3 {
    return v.mulScalar(1 / v.len());
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

pub const VecComponent = enum { x, y, z, w };
pub inline fn swizzle(
    v: @Vector(4, f32),
    xc: VecComponent,
    yc: VecComponent,
    zc: VecComponent,
    wc: VecComponent,
) @Vector(4, f32) {
    return @shuffle(f32, v, undefined, [4]f32{
        @intFromEnum(xc),
        @intFromEnum(yc),
        @intFromEnum(zc),
        @intFromEnum(wc),
    });
}

pub fn inverse(mt: Mat4x4) Mat4x4 {
    const mtz = [4]@Vector(4, f32){
        mt.v[0].v,
        mt.v[1].v,
        mt.v[2].v,
        mt.v[3].v,
    };

    var v0: [4]@Vector(4, f32) = undefined;
    var v1: [4]@Vector(4, f32) = undefined;

    v0[0] = swizzle(mtz[2], .x, .x, .y, .y);
    v1[0] = swizzle(mtz[3], .z, .w, .z, .w);
    v0[1] = swizzle(mtz[0], .x, .x, .y, .y);
    v1[1] = swizzle(mtz[1], .z, .w, .z, .w);
    v0[2] = @shuffle(f32, mtz[2], mtz[0], [4]i32{ 0, 2, ~@as(i32, 0), ~@as(i32, 2) });
    v1[2] = @shuffle(f32, mtz[3], mtz[1], [4]i32{ 1, 3, ~@as(i32, 1), ~@as(i32, 3) });

    var d0 = v0[0] * v1[0];
    var d1 = v0[1] * v1[1];
    var d2 = v0[2] * v1[2];

    v0[0] = swizzle(mtz[2], .z, .w, .z, .w);
    v1[0] = swizzle(mtz[3], .x, .x, .y, .y);
    v0[1] = swizzle(mtz[0], .z, .w, .z, .w);
    v1[1] = swizzle(mtz[1], .x, .x, .y, .y);
    v0[2] = @shuffle(f32, mtz[2], mtz[0], [4]i32{ 1, 3, ~@as(i32, 1), ~@as(i32, 3) });
    v1[2] = @shuffle(f32, mtz[3], mtz[1], [4]i32{ 0, 2, ~@as(i32, 0), ~@as(i32, 2) });

    d0 = -v0[0] * v1[0] + d0;
    d1 = -v0[1] * v1[1] + d1;
    d2 = -v0[2] * v1[2] + d2;

    v0[0] = swizzle(mtz[1], .y, .z, .x, .y);
    v1[0] = @shuffle(f32, d0, d2, [4]i32{ ~@as(i32, 1), 1, 3, 0 });
    v0[1] = swizzle(mtz[0], .z, .x, .y, .x);
    v1[1] = @shuffle(f32, d0, d2, [4]i32{ 3, ~@as(i32, 1), 1, 2 });
    v0[2] = swizzle(mtz[3], .y, .z, .x, .y);
    v1[2] = @shuffle(f32, d1, d2, [4]i32{ ~@as(i32, 3), 1, 3, 0 });
    v0[3] = swizzle(mtz[2], .z, .x, .y, .x);
    v1[3] = @shuffle(f32, d1, d2, [4]i32{ 3, ~@as(i32, 3), 1, 2 });

    var c0 = v0[0] * v1[0];
    var c2 = v0[1] * v1[1];
    var c4 = v0[2] * v1[2];
    var c6 = v0[3] * v1[3];

    v0[0] = swizzle(mtz[1], .z, .w, .y, .z);
    v1[0] = @shuffle(f32, d0, d2, [4]i32{ 3, 0, 1, ~@as(i32, 0) });
    v0[1] = swizzle(mtz[0], .w, .z, .w, .y);
    v1[1] = @shuffle(f32, d0, d2, [4]i32{ 2, 1, ~@as(i32, 0), 0 });
    v0[2] = swizzle(mtz[3], .z, .w, .y, .z);
    v1[2] = @shuffle(f32, d1, d2, [4]i32{ 3, 0, 1, ~@as(i32, 2) });
    v0[3] = swizzle(mtz[2], .w, .z, .w, .y);
    v1[3] = @shuffle(f32, d1, d2, [4]i32{ 2, 1, ~@as(i32, 2), 0 });

    c0 = -v0[0] * v1[0] + c0;
    c2 = -v0[1] * v1[1] + c2;
    c4 = -v0[2] * v1[2] + c4;
    c6 = -v0[3] * v1[3] + c6;

    v0[0] = swizzle(mtz[1], .w, .x, .w, .x);
    v1[0] = @shuffle(f32, d0, d2, [4]i32{ 2, ~@as(i32, 1), ~@as(i32, 0), 2 });
    v0[1] = swizzle(mtz[0], .y, .w, .x, .z);
    v1[1] = @shuffle(f32, d0, d2, [4]i32{ ~@as(i32, 1), 0, 3, ~@as(i32, 0) });
    v0[2] = swizzle(mtz[3], .w, .x, .w, .x);
    v1[2] = @shuffle(f32, d1, d2, [4]i32{ 2, ~@as(i32, 3), ~@as(i32, 2), 2 });
    v0[3] = swizzle(mtz[2], .y, .w, .x, .z);
    v1[3] = @shuffle(f32, d1, d2, [4]i32{ ~@as(i32, 3), 0, 3, ~@as(i32, 2) });

    const c1 = -v0[0] * v1[0] + c0;
    const c3 = v0[1] * v1[1] + c2;
    const c5 = -v0[2] * v1[2] + c4;
    const c7 = v0[3] * v1[3] + c6;

    c0 = v0[0] * v1[0] + c0;
    c2 = -v0[1] * v1[1] + c2;
    c4 = v0[2] * v1[2] + c4;
    c6 = -v0[3] * v1[3] + c6;

    var mr = mat4x4(
        &vec4(c0[0], c1[1], c0[2], c1[3]),
        &vec4(c2[0], c3[1], c2[2], c3[3]),
        &vec4(c4[0], c5[1], c4[2], c5[3]),
        &vec4(c6[0], c7[1], c6[2], c7[3]),
    );

    const det = mr.col(0).dot(&mt.col(0));

    if (std.math.approxEqAbs(f32, det, 0.0, std.math.floatEps(f32))) {
        return mat4x4(
            &vec4(0.0, 0.0, 0.0, 0.0),
            &vec4(0.0, 0.0, 0.0, 0.0),
            &vec4(0.0, 0.0, 0.0, 0.0),
            &vec4(0.0, 0.0, 0.0, 0.0),
        );
    }

    const scale = 1 / det;
    mr.v[0] = mr.v[0].mulScalar(scale);
    mr.v[1] = mr.v[1].mulScalar(scale);
    mr.v[2] = mr.v[2].mulScalar(scale);
    mr.v[3] = mr.v[3].mulScalar(scale);
    return mr;
}

pub fn lookAtRh(eyepos: Vec3, focuspos: Vec3, updir: Vec3) Mat4x4 {
    return lookToLh(eyepos, eyepos.sub(&focuspos), updir);
}

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
