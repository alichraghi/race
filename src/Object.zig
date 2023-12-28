const std = @import("std");
const core = @import("mach-core");
const gpu = core.gpu;
const Model = @import("Model.zig");
const math = @import("mach").math;
const Vec2 = math.Vec2;
const Vec3 = math.Vec3;
const Mat2x2 = math.Mat2x2;
const vec2 = math.vec2;
const vec3 = math.vec3;
const mat2x2 = math.mat2x2;

var id_index: u32 = 0;

const Object = @This();

id: u32,
model: Model,
transform2d: Transform2D,
color: Vec3,

pub fn init(model: Model) Object {
    const id = id_index;
    id_index += 1;
    return .{
        .id = id,
        .model = model,
        .transform2d = .{},
        .color = vec3(1, 1, 1),
    };
}

pub fn render(object: *Object, pass: *gpu.RenderPassEncoder) void {
    object.model.writeUBO(0, .{
        .transform = @bitCast(object.transform2d.mat2().v),
        .offset = object.transform2d.translation.v,
        .color = object.color.v,
    });
    object.model.bind(0, pass);
    object.model.draw(pass);
}

const Transform2D = struct {
    translation: Vec2 = vec2(0, 0),
    scale: Vec2 = vec2(1, 1),
    /// in radians
    rotation: f32 = 0,

    pub fn mat2(transform: Transform2D) Mat2x2 {
        const rot_sin = @sin(transform.rotation);
        const rot_cos = @cos(transform.rotation);
        const rot = mat2x2(&vec2(rot_cos, rot_sin), &vec2(-rot_sin, rot_cos));
        const scale = mat2x2(&vec2(transform.scale.x(), 0), &vec2(0, transform.scale.y()));
        return rot.mul(&scale);
    }
};
