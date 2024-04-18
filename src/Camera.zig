const mach = @import("mach");
const math = @import("math.zig");
const Vec3 = math.Vec3;
const Vec4 = math.Vec4;
const Mat4x4 = math.Mat4x4;
const vec4 = math.vec4;
const mat4x4 = math.mat4x4;

projection: Mat4x4 = Mat4x4.ident,
view: Mat4x4 = Mat4x4.ident,

pub fn perspective(fovy: f32, aspect: f32, near: f32, far: f32) Mat4x4 {
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

pub fn lookAt(eye: Vec3, dir: Vec3, up: Vec3) Mat4x4 {
    const f = math.normalize(eye.sub(&dir));
    const s = math.normalize(up.cross(&f));
    const u = f.cross(&s);
    return mat4x4(
        &vec4(-s.x(), s.y(), s.z(), -s.dot(&eye)),
        &vec4(-u.x(), u.y(), u.z(), -u.dot(&eye)),
        &vec4(-f.x(), f.y(), f.z(), -f.dot(&eye)),
        &vec4(0, 0, 0, 1),
    );
}
