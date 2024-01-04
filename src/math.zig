const math = @import("mach").math;
const Vec3 = math.Vec3;
const vec3 = math.vec3;

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
