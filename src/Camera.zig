const mach = @import("mach");
const math = @import("math.zig");
const Vec3 = math.Vec3;
const Vec4 = math.Vec4;
const Mat4x4 = math.Mat4x4;
const vec4 = math.vec4;
const mat4x4 = math.mat4x4;

projection: Mat4x4 = Mat4x4.ident,
view: Mat4x4 = Mat4x4.ident,
