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

pub const Transform = struct {
    translation: Vec3 = vec3(0, 0, 0),
    rotation: Vec3 = vec3(0, 0, 0),
    scale: Vec3 = vec3(1, 1, 1),

    pub fn mat(transform: Transform) Mat4x4 {
        return Mat4x4.translate(transform.translation)
            .mul(&Mat4x4.rotateZ(transform.rotation.z())
            .mul(&Mat4x4.rotateY(transform.rotation.y()))
            .mul(&Mat4x4.rotateX(transform.rotation.x())))
            .mul(&Mat4x4.scale(transform.scale));
    }

    pub fn normalMat(transform: Transform) Mat3x3 {
        const c3 = @cos(transform.rotation.z());
        const s3 = @sin(transform.rotation.z());
        const c2 = @cos(transform.rotation.x());
        const s2 = @sin(transform.rotation.x());
        const c1 = @cos(transform.rotation.y());
        const s1 = @sin(transform.rotation.y());
        const inv_scale = vec3(1, 1, 1).div(&transform.scale);

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
};
