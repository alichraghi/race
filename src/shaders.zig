const mach = @import("mach");
const math = @import("math.zig");
const gpu = mach.gpu;
const Vec3 = math.Vec3;
const Vec4 = math.Vec4;
const Mat3x3 = math.Mat3x3;
const Mat4x4 = math.Mat4x4;

pub const CameraUniform = extern struct {
    projection_view: Mat4x4,
    inverse_projection_view: Mat4x4,
};

pub const CameraUniform2 = extern struct {
    view: Mat4x4,
    projection_view: Mat4x4,
};

pub const InstanceData = extern struct {
    model: Mat4x4,
    model_normal: Mat4x4,

    pub const attributes = [_]gpu.VertexAttribute{
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "model") + @sizeOf(Vec4) * 0,
            .shader_location = 3,
        },
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "model") + @sizeOf(Vec4) * 1,
            .shader_location = 4,
        },
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "model") + @sizeOf(Vec4) * 2,
            .shader_location = 5,
        },
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "model") + @sizeOf(Vec4) * 3,
            .shader_location = 6,
        },
        .{
            .format = .float32x3,
            .offset = @offsetOf(InstanceData, "model_normal") + @sizeOf(Vec3) * 0,
            .shader_location = 7,
        },
        .{
            .format = .float32x3,
            .offset = @offsetOf(InstanceData, "model_normal") + @sizeOf(Vec3) * 1,
            .shader_location = 8,
        },
        .{
            .format = .float32x3,
            .offset = @offsetOf(InstanceData, "model_normal") + @sizeOf(Vec3) * 2,
            .shader_location = 9,
        },
        .{
            .format = .float32x3,
            .offset = @offsetOf(InstanceData, "model_normal") + @sizeOf(Vec3) * 3,
            .shader_location = 10,
        },
    };

    pub const layout = gpu.VertexBufferLayout.init(.{
        .array_stride = @sizeOf(InstanceData),
        .step_mode = .instance,
        .attributes = &attributes,
    });
};

pub const Light = extern struct {
    position: Vec3,
    color: Vec4,
    radius: f32,
};

pub const LightBuffer = extern struct {
    len: u32,
    lights: [10]Light,
};

pub const max_num_lights = 10;
