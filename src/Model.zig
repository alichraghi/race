const std = @import("std");
const core = @import("mach-core");
const gpu = core.gpu;

const Model = @This();

pub const Vertex = struct {
    position: @Vector(2, f32),
    color: @Vector(3, f32),

    pub const attributes = [_]gpu.VertexAttribute{
        .{
            .format = .float32x2,
            .offset = @offsetOf(Vertex, "position"),
            .shader_location = 0,
        },
        .{
            .format = .float32x3,
            .offset = @offsetOf(Vertex, "color"),
            .shader_location = 1,
        },
    };

    pub const layout = gpu.VertexBufferLayout.init(.{
        .array_stride = @sizeOf(Vertex),
        .step_mode = .vertex,
        .attributes = &attributes,
    });
};

pub const UBO = struct {
    transform: @Vector(4, f32) align(16),
    offset: @Vector(2, f32) align(16),
    color: @Vector(3, f32),

    pub const bind_group_layout_entry = gpu.BindGroupLayout.Entry.buffer(
        0,
        .{ .vertex = true, .fragment = true },
        .uniform,
        true,
        0,
    );
};

vertex_buf: *gpu.Buffer,
uniform_buf: *gpu.Buffer,
bind_group_layout: *gpu.BindGroupLayout,
bind_group: *gpu.BindGroup,
vertices_count: u32,
uniform_stride: u32,

fn ceilToNextMultiple(value: u32, step: u32) u32 {
    const divide_and_ceil = value / step + @as(u32, if (value % step == 0) 0 else 1);
    return step * divide_and_ceil;
}

pub fn init(vertices: []const Vertex, uniforms_count: u32) Model {
    var limits = gpu.SupportedLimits{};
    _ = core.device.getLimits(&limits);
    const uniform_stride = ceilToNextMultiple(
        @sizeOf(Model.UBO),
        limits.limits.min_uniform_buffer_offset_alignment,
    );

    const vertex_buf = createVertexBuffer(vertices);
    const uniform_buf = createUniformBuffer(uniform_stride, uniforms_count);
    const bind_group_layout = core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{ .entries = &.{UBO.bind_group_layout_entry} }),
    );
    const bind_group = core.device.createBindGroup(
        &gpu.BindGroup.Descriptor.init(.{
            .layout = bind_group_layout,
            .entries = &.{
                gpu.BindGroup.Entry.buffer(
                    0,
                    uniform_buf,
                    0,
                    @sizeOf(UBO),
                ),
            },
        }),
    );
    return .{
        .vertex_buf = vertex_buf,
        .uniform_buf = uniform_buf,
        .bind_group_layout = bind_group_layout,
        .bind_group = bind_group,
        .vertices_count = @intCast(vertices.len),
        .uniform_stride = uniform_stride,
    };
}

pub fn deinit(model: Model) void {
    model.vertex_buf.release();
    model.bind_group_layout.release();
    model.bind_group.release();
    model.uniform_buf.release();
}

pub fn writeUBO(model: *Model, index: u32, ubo: UBO) void {
    core.queue.writeBuffer(model.uniform_buf, index * model.uniform_stride, &[_]UBO{ubo});
}

pub fn bind(model: Model, index: u32, pass: *gpu.RenderPassEncoder) void {
    pass.setVertexBuffer(0, model.vertex_buf, 0, @sizeOf(Vertex) * model.vertices_count);
    pass.setBindGroup(0, model.bind_group, &.{index * model.uniform_stride});
}

pub fn draw(model: Model, pass: *gpu.RenderPassEncoder) void {
    pass.draw(model.vertices_count, 1, 0, 0);
}

fn createVertexBuffer(vertices: []const Vertex) *gpu.Buffer {
    const vertex_buffer = core.device.createBuffer(&.{
        .usage = .{ .vertex = true },
        .size = @sizeOf(Vertex) * vertices.len,
        .mapped_at_creation = .true,
    });
    const vertex_mapped = vertex_buffer.getMappedRange(Vertex, 0, vertices.len);
    @memcpy(vertex_mapped.?, vertices[0..]);
    vertex_buffer.unmap();
    return vertex_buffer;
}

fn createUniformBuffer(uniform_stride: u32, uniforms_count: u32) *gpu.Buffer {
    const uniform_buffer = core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = uniforms_count * uniform_stride,
        .mapped_at_creation = .false,
    });
    return uniform_buffer;
}
