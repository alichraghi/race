const math = @import("math.zig");
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

pub fn lookAt(camera: *Camera, eye: Vec3, dir: Vec3, up: Vec3) void {
    const f = math.normalize(eye.sub(&dir));
    const s = math.normalize(up.cross(&f));
    const u = f.cross(&s);
    camera.view = mat4x4(
        &vec4(s.x(), s.y(), s.z(), -s.dot(&eye)),
        &vec4(u.x(), u.y(), u.z(), -u.dot(&eye)),
        &vec4(f.x(), f.y(), f.z(), -f.dot(&eye)),
        &vec4(0, 0, 0, 1),
    );
}

pub fn perspective(camera: *Camera, fovy: f32, aspect: f32, near: f32, far: f32) void {
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
