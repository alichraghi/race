const math = @import("mach").math;
const Vec3 = math.Vec3;
const Mat3x3 = math.Mat3x3;
const Mat4x4 = math.Mat4x4;
const vec3 = math.vec3;
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
