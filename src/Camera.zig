const std = @import("std");
const Model = @import("Model.zig");
const mach = @import("mach");
const core = mach.core;
const gpu = mach.gpu;
const math = mach.math;
const Engine = mach.Engine;
const Vec3 = math.Vec3;
const Vec4 = math.Vec4;
const Mat4x4 = math.Mat4x4;
const vec3 = math.vec3;
const vec4 = math.vec4;
const mat4x4 = math.mat4x4;

pub const name = .camera;
pub const Mod = mach.Mod(@This());
pub const components = struct {
    pub const projection = Mat4x4;
    pub const view = Mat4x4;
};

pub const local = struct {
    pub fn init(camera: *Mod, entity: mach.ecs.EntityID) !void {
        camera.state = .{};
        try camera.set(entity, .projection, Mat4x4.ident);
        try camera.set(entity, .view, Mat4x4.ident);
    }

    pub fn deinit(camera: *Mod) !void {
        _ = camera;
    }

    pub fn setViewDirection(camera: *Mod, entity: mach.ecs.EntityID, position: Vec3, direction: Vec3, up: Vec3) !void {
        const w = direction.normalize(0);
        const u = w.cross(&up).normalize(0);
        const v = w.cross(&u);
        try camera.set(entity, .view, mat4x4(
            &vec4(u.x(), v.x(), w.x(), 0),
            &vec4(u.y(), v.y(), w.y(), 0),
            &vec4(u.z(), v.z(), w.z(), 0),
            &vec4(-u.dot(&position), -v.dot(&position), -w.dot(&position), 1),
        ));
    }

    pub fn setViewTarget(camera: *Mod, entity: mach.ecs.EntityID, position: Vec3, target: Vec3, up: Vec3) !void {
        try camera.set(entity, .projection, Mat4x4.ident);
        try setViewDirection(camera, entity, position, target.sub(&position), up);
    }

    pub fn setOrthographicProjection(
        camera: *Mod,
        entity: mach.ecs.EntityID,
        aspect: f32,
        scale: f32,
        near: f32,
        far: f32,
    ) !void {
        try camera.set(entity, .projection, mat4x4(
            &vec4(1.0 / scale, 0.0, 0.0, 0.0),
            &vec4(0.0, aspect / scale, 0.0, 0.0),
            &vec4(0.0, 0.0, 1.0 / (far - near), -near / (far - near)),
            &vec4(0.0, 0.0, 0.0, 1.0),
        ));
    }

    pub fn setPerspectiveProjection(
        camera: *Mod,
        entity: mach.ecs.EntityID,
        fovy: f32,
        aspect: f32,
        near: f32,
        far: f32,
    ) !void {
        const tan_half_fovy = @tan(fovy / 2);
        try camera.set(entity, .projection, mat4x4(
            &vec4(1 / (aspect * tan_half_fovy), 0, 0, 0),
            &vec4(0, 1 / (tan_half_fovy), 0, 0),
            &vec4(0, 0, far / (far - near), 1),
            &vec4(0, 0, -(far * near) / (far - near), 0),
        ));
    }
};
