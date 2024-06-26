const mach = @import("mach");
const math = @import("math.zig");
const gpu = mach.gpu;
const Vec2 = math.Vec2;
const Vec3 = math.Vec3;
const Vec4 = math.Vec4;
const Mat3x3 = math.Mat3x3;
const Mat4x4 = math.Mat4x4;

pub const Vertex = extern struct {
    position: Vec3,
    normal: Vec3,
    tangent: Vec4,
    uv: Vec2,

    pub const attributes = [_]gpu.VertexAttribute{
        .{
            .format = .float32x3,
            .offset = @offsetOf(Vertex, "position"),
            .shader_location = 0,
        },
        .{
            .format = .float32x3,
            .offset = @offsetOf(Vertex, "normal"),
            .shader_location = 1,
        },
        .{
            .format = .float32x4,
            .offset = @offsetOf(Vertex, "tangent"),
            .shader_location = 2,
        },
        .{
            .format = .float32x2,
            .offset = @offsetOf(Vertex, "uv"),
            .shader_location = 3,
        },
    };

    pub const layout = gpu.VertexBufferLayout.init(.{
        .array_stride = @sizeOf(Vertex),
        .step_mode = .vertex,
        .attributes = &attributes,
    });
};

pub const InstanceData = extern struct {
    model: Mat4x4,
    model_normal: Mat4x4,

    pub const attributes = [_]gpu.VertexAttribute{
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "model") + @sizeOf(Vec4) * 0,
            .shader_location = 4,
        },
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "model") + @sizeOf(Vec4) * 1,
            .shader_location = 5,
        },
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "model") + @sizeOf(Vec4) * 2,
            .shader_location = 6,
        },
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "model") + @sizeOf(Vec4) * 3,
            .shader_location = 7,
        },
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "model_normal") + @sizeOf(Vec4) * 0,
            .shader_location = 8,
        },
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "model_normal") + @sizeOf(Vec4) * 1,
            .shader_location = 9,
        },
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "model_normal") + @sizeOf(Vec4) * 2,
            .shader_location = 10,
        },
        .{
            .format = .float32x4,
            .offset = @offsetOf(InstanceData, "model_normal") + @sizeOf(Vec4) * 3,
            .shader_location = 11,
        },
    };

    pub const layout = gpu.VertexBufferLayout.init(.{
        .array_stride = @sizeOf(InstanceData),
        .step_mode = .instance,
        .attributes = &attributes,
    });
};

pub const CameraUniform = extern struct {
    position: Vec3,
    view: Mat4x4,
    projection_view: Mat4x4,
    inverse_projection_view: Mat4x4,
};

pub const Light = extern struct {
    position: Vec3,
    color: Vec4,
    radius: f32,
};

pub const LightBuffer = extern struct {
    len: u32,
    lights: [max_num_lights]Light,
};

pub const max_num_lights = 128;

pub const RenderMode = enum(u32) {
    render = 0,
    debug_albedo = 1,
    debug_normal = 2,
    debug_depth = 3,

    pub const max = @typeInfo(RenderMode).Enum.fields[@typeInfo(RenderMode).Enum.fields.len - 1].value;
};
