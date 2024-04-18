const mach = @import("mach");
const math = @import("math.zig");
const gpu = mach.gpu;
const Vec3 = math.Vec3;
const Vec4 = math.Vec4;
const Mat3x3 = math.Mat3x3;
const Mat4x4 = math.Mat4x4;

pub const CameraUniform = struct {
    projection: Mat4x4,
    view: Mat4x4,
};

pub const LightUniform = struct {
    position: Vec3,
    color: Vec4,
    radius: f32,
};

pub const ObjectUniform = struct {
    model: Mat4x4,
    normal: Mat3x3,
};

pub const max_lights = 10;
pub const LightListUniform = struct {
    ambient_color: Vec4,
    lights: [max_lights]LightUniform,
    len: u32,
};
