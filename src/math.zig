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

pub fn ceilToNextMultiple(value: u32, step: u32) u32 {
    const divide_and_ceil = value / step + @as(u32, if (value % step == 0) 0 else 1);
    return step * divide_and_ceil;
}

pub fn transform(translation: Vec3, rotation: Vec3, scale: Vec3) Mat4x4 {
    return Mat4x4.translate(translation)
        .mul(&Mat4x4.rotateZ(rotation.z()))
        .mul(&Mat4x4.rotateY(rotation.y()))
        .mul(&Mat4x4.rotateX(rotation.x()))
        .mul(&Mat4x4.scale(scale));
}

pub fn transformNormal(rotation: Vec3, scale: Vec3) Mat4x4 {
    const c3 = @cos(rotation.z());
    const s3 = @sin(rotation.z());
    const c2 = @cos(rotation.x());
    const s2 = @sin(rotation.x());
    const c1 = @cos(rotation.y());
    const s1 = @sin(rotation.y());
    const inv_scale = vec3(1, 1, 1).div(&scale);

    return mat4x4(
        &vec4(c1 * c3 + s1 * s2 * s3, c2 * s3, c1 * s2 * s3 - c3 * s1, 0).mulScalar(inv_scale.x()),
        &vec4(c3 * s1 * s2 + c1 * s3, c2 * c3, c1 * c3 * s2 - s1 * s3, 0).mulScalar(inv_scale.y()),
        &vec4(c2 * s1, -s2, c1 * c2, 0).mulScalar(inv_scale.z()),
        &vec4(0, 0, 0, 1),
    );
}

// pub fn inverse(a: Mat4x4) Mat4x4 {
//     const a00 = a.v[0].v[0];
//     const a01 = a.v[0].v[1];
//     const a02 = a.v[0].v[2];
//     const a03 = a.v[0].v[3];
//     const a10 = a.v[1].v[0];
//     const a11 = a.v[1].v[1];
//     const a12 = a.v[1].v[2];
//     const a13 = a.v[1].v[3];
//     const a20 = a.v[2].v[0];
//     const a21 = a.v[2].v[1];
//     const a22 = a.v[2].v[2];
//     const a23 = a.v[2].v[3];
//     const a30 = a.v[3].v[0];
//     const a31 = a.v[3].v[1];
//     const a32 = a.v[3].v[2];
//     const a33 = a.v[3].v[3];

//     const b00 = a00 * a11 - a01 * a10;
//     const b01 = a00 * a12 - a02 * a10;
//     const b02 = a00 * a13 - a03 * a10;
//     const b03 = a01 * a12 - a02 * a11;
//     const b04 = a01 * a13 - a03 * a11;
//     const b05 = a02 * a13 - a03 * a12;
//     const b06 = a20 * a31 - a21 * a30;
//     const b07 = a20 * a32 - a22 * a30;
//     const b08 = a20 * a33 - a23 * a30;
//     const b09 = a21 * a32 - a22 * a31;
//     const b10 = a21 * a33 - a23 * a31;
//     const b11 = a22 * a33 - a23 * a32;

//     // Calculate the determinant
//     var det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;

//     det = 1.0 / det;

//     const out = mat4x4(
//         &vec4(
//             (a11 * b11 - a12 * b10 + a13 * b09) * det, // 0
//             (a02 * b10 - a01 * b11 - a03 * b09) * det, // 1
//             (a31 * b05 - a32 * b04 + a33 * b03) * det, // 2
//             (a22 * b04 - a21 * b05 - a23 * b03) * det, // 3
//         ),
//         &vec4(
//             (a12 * b08 - a10 * b11 - a13 * b07) * det, // 4
//             (a00 * b11 - a02 * b08 + a03 * b07) * det, // 5
//             (a32 * b02 - a30 * b05 - a33 * b01) * det, // 6
//             (a20 * b05 - a22 * b02 + a23 * b01) * det, // 7
//         ),
//         &vec4(
//             (a10 * b10 - a11 * b08 + a13 * b06) * det, // 8
//             (a01 * b08 - a00 * b10 - a03 * b06) * det, // 9
//             (a30 * b04 - a31 * b02 + a33 * b00) * det, // 10
//             (a21 * b02 - a20 * b04 - a23 * b00) * det, // 11
//         ),
//         &vec4(
//             (a11 * b07 - a10 * b09 - a12 * b06) * det, // 12
//             (a00 * b09 - a01 * b07 + a02 * b06) * det, // 13
//             (a31 * b01 - a30 * b03 - a32 * b00) * det, // 14
//             (a20 * b03 - a21 * b01 + a22 * b00) * det, // 15
//         ),
//     );

//     return out;
// }
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
