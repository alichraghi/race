const std = @import("std");
const build_options = @import("build_options");
const mach = @import("mach");
const Renderer = @import("Renderer.zig");
const Model = @import("Model.zig");
const Camera = @import("Camera.zig");
const shaders = @import("shaders.zig");
const math = @import("math.zig");
const gpu = mach.gpu;
const Vec3 = math.Vec3;
const Vec4 = math.Vec4;
const Mat3x3 = math.Mat3x3;
const Mat4x4 = math.Mat4x4;
const vec3 = math.vec3;
const vec4 = math.vec4;
const mat3x3 = math.mat3x3;
const mat4x4 = math.mat4x4;

const Object = @This();

pub const name = .object;
pub const Mod = mach.Mod(Object);

pub const components = .{
    .model = .{ .type = Model },
    .transform = .{ .type = Transform },
    .instances = .{ .type = []Transform },
};

pub const Transform = struct {
    translation: Vec3 = vec3(0, 0, 0),
    rotation: Vec3 = vec3(0, 0, 0),
    scale: Vec3 = vec3(1, 1, 1),
};
