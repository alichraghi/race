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

pub const InstanceData = struct {
    transform: Mat4x4,
    normal: Mat3x3,

    pub const attributes = [_]gpu.VertexAttribute{
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "transform") + @sizeOf(Vec4) * 0,
            .shader_location = 4,
        },
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "transform") + @sizeOf(Vec4) * 1,
            .shader_location = 5,
        },
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "transform") + @sizeOf(Vec4) * 2,
            .shader_location = 6,
        },
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "transform") + @sizeOf(Vec4) * 3,
            .shader_location = 7,
        },
        .{
            .format = .float32x3,
            .offset = @offsetOf(InstanceData, "normal") + @sizeOf(Vec3) * 0,
            .shader_location = 8,
        },
        .{
            .format = .float32x3,
            .offset = @offsetOf(InstanceData, "normal") + @sizeOf(Vec3) * 1,
            .shader_location = 9,
        },
        .{
            .format = .float32x3,
            .offset = @offsetOf(InstanceData, "normal") + @sizeOf(Vec3) * 2,
            .shader_location = 10,
        },
    };

    pub const layout = gpu.VertexBufferLayout.init(.{
        .array_stride = @sizeOf(InstanceData),
        .step_mode = .instance,
        .attributes = &attributes,
    });
};

pub const max_lights = 10;
pub const LightListUniform = struct {
    ambient_color: Vec4,
    lights: [max_lights]LightUniform,
    len: u32,
};
