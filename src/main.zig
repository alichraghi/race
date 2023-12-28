const std = @import("std");
const math = @import("mach").math;
const core = @import("mach-core");
const gpu = core.gpu;
const Model = @import("Model.zig");
const Object = @import("Object.zig");
comptime {
    std.testing.refAllDecls(Object);
}

pub const App = @This();

title_timer: core.Timer,
pipeline: *gpu.RenderPipeline,
object: Object,

pub fn init(app: *App) !void {
    try core.init(.{});

    const shader_module = core.device.createShaderModuleWGSL("shader.wgsl", @embedFile("shader.wgsl"));
    defer shader_module.release();

    // Fragment state
    const blend = gpu.BlendState{};
    const color_target = gpu.ColorTargetState{
        .format = core.descriptor.format,
        .blend = &blend,
        .write_mask = gpu.ColorWriteMaskFlags.all,
    };
    const fragment = gpu.FragmentState.init(.{
        .module = shader_module,
        .entry_point = "frag_main",
        .targets = &.{color_target},
    });
    const model = Model.init(&.{
        .{ .position = .{ 0.0, 0.5 }, .color = .{ 1, 0, 0 } },
        .{ .position = .{ -0.5, -0.5 }, .color = .{ 0, 1, 0 } },
        .{ .position = .{ 0.5, -0.5 }, .color = .{ 0, 0, 1 } },
    }, 2);
    const object = Object.init(model);
    const pipeline_layout = core.device.createPipelineLayout(
        &gpu.PipelineLayout.Descriptor.init(.{ .bind_group_layouts = &.{model.bind_group_layout} }),
    );
    const pipeline_descriptor = gpu.RenderPipeline.Descriptor{
        .layout = pipeline_layout,
        .fragment = &fragment,
        .vertex = gpu.VertexState.init(.{
            .module = shader_module,
            .entry_point = "vertex_main",
            .buffers = &.{Model.Vertex.layout},
        }),
        .primitive = .{
            .cull_mode = .back,
        },
    };
    const pipeline = core.device.createRenderPipeline(&pipeline_descriptor);

    app.* = .{
        .title_timer = try core.Timer.start(),
        .pipeline = pipeline,
        .object = object,
    };
}

pub fn deinit(app: *App) void {
    defer core.deinit();
    app.pipeline.release();
}

pub fn update(app: *App) !bool {
    var iter = core.pollEvents();
    while (iter.next()) |event| {
        switch (event) {
            .close => return true,
            else => {},
        }
    }

    const queue = core.queue;
    const back_buffer_view = core.swap_chain.getCurrentTextureView().?;
    const color_attachment = gpu.RenderPassColorAttachment{
        .view = back_buffer_view,
        .clear_value = std.mem.zeroes(gpu.Color),
        .load_op = .clear,
        .store_op = .store,
    };

    const encoder = core.device.createCommandEncoder(null);
    const render_pass_info = gpu.RenderPassDescriptor.init(.{ .color_attachments = &.{color_attachment} });

    const pass = encoder.beginRenderPass(&render_pass_info);
    pass.setPipeline(app.pipeline);

    app.object.transform2d.translation = app.object.transform2d.translation.addScalar(0.001);
    app.object.transform2d.rotation += 0.01;
    app.object.transform2d.scale = app.object.transform2d.scale.addScalar(0.0001);
    app.object.color.v[0] -= 0.01;
    app.object.color.v[1] -= 0.003;
    app.object.color.v[2] -= 0.005;
    app.object.render(pass);

    pass.end();
    pass.release();

    const command = encoder.finish(null);
    encoder.release();

    queue.submit(&[_]*gpu.CommandBuffer{command});
    command.release();
    core.swap_chain.present();
    back_buffer_view.release();

    // update the window title every second
    if (app.title_timer.read() >= 1.0) {
        app.title_timer.reset();
        try core.printTitle("Triangle [ {d}fps ] [ Input {d}hz ]", .{
            core.frameRate(),
            core.inputRate(),
        });
    }

    return false;
}
