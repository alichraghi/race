const std = @import("std");
const Model = @import("Model.zig");
const Object = @import("Object.zig");
const Camera = @import("Camera.zig");
const mach = @import("mach");
const math = mach.math;
const core = mach.core;
const gpu = mach.gpu;

pub const name = .game;
pub const Mod = mach.Mod(@This());

title_timer: core.Timer,
depth_texture: *gpu.Texture,
depth_view: *gpu.TextureView,
// player: mach.ecs.EntityID,

const vertices = [_]Model.Vertex{
    .{ .position = .{ -0.5, -0.5, -0.5 }, .color = .{ 0.9, 0.9, 0.9 } },
    .{ .position = .{ -0.5, 0.5, 0.5 }, .color = .{ 0.9, 0.9, 0.9 } },
    .{ .position = .{ -0.5, -0.5, 0.5 }, .color = .{ 0.9, 0.9, 0.9 } },
    .{ .position = .{ -0.5, -0.5, -0.5 }, .color = .{ 0.9, 0.9, 0.9 } },
    .{ .position = .{ -0.5, 0.5, -0.5 }, .color = .{ 0.9, 0.9, 0.9 } },
    .{ .position = .{ -0.5, 0.5, 0.5 }, .color = .{ 0.9, 0.9, 0.9 } },

    .{ .position = .{ 0.5, -0.5, -0.5 }, .color = .{ 0.8, 0.8, 0.1 } },
    .{ .position = .{ 0.5, 0.5, 0.5 }, .color = .{ 0.8, 0.8, 0.1 } },
    .{ .position = .{ 0.5, -0.5, 0.5 }, .color = .{ 0.8, 0.8, 0.1 } },
    .{ .position = .{ 0.5, -0.5, -0.5 }, .color = .{ 0.8, 0.8, 0.1 } },
    .{ .position = .{ 0.5, 0.5, -0.5 }, .color = .{ 0.8, 0.8, 0.1 } },
    .{ .position = .{ 0.5, 0.5, 0.5 }, .color = .{ 0.8, 0.8, 0.1 } },

    .{ .position = .{ -0.5, -0.5, -0.5 }, .color = .{ 0.9, 0.6, 0.1 } },
    .{ .position = .{ 0.5, -0.5, 0.5 }, .color = .{ 0.9, 0.6, 0.1 } },
    .{ .position = .{ -0.5, -0.5, 0.5 }, .color = .{ 0.9, 0.6, 0.1 } },
    .{ .position = .{ -0.5, -0.5, -0.5 }, .color = .{ 0.9, 0.6, 0.1 } },
    .{ .position = .{ 0.5, -0.5, -0.5 }, .color = .{ 0.9, 0.6, 0.1 } },
    .{ .position = .{ 0.5, -0.5, 0.5 }, .color = .{ 0.9, 0.6, 0.1 } },

    .{ .position = .{ -0.5, 0.5, -0.5 }, .color = .{ 0.8, 0.1, 0.1 } },
    .{ .position = .{ 0.5, 0.5, 0.5 }, .color = .{ 0.8, 0.1, 0.1 } },
    .{ .position = .{ -0.5, 0.5, 0.5 }, .color = .{ 0.8, 0.1, 0.1 } },
    .{ .position = .{ -0.5, 0.5, -0.5 }, .color = .{ 0.8, 0.1, 0.1 } },
    .{ .position = .{ 0.5, 0.5, -0.5 }, .color = .{ 0.8, 0.1, 0.1 } },
    .{ .position = .{ 0.5, 0.5, 0.5 }, .color = .{ 0.8, 0.1, 0.1 } },

    .{ .position = .{ -0.5, -0.5, 0.5 }, .color = .{ 0.1, 0.1, 0.8 } },
    .{ .position = .{ 0.5, 0.5, 0.5 }, .color = .{ 0.1, 0.1, 0.8 } },
    .{ .position = .{ -0.5, 0.5, 0.5 }, .color = .{ 0.1, 0.1, 0.8 } },
    .{ .position = .{ -0.5, -0.5, 0.5 }, .color = .{ 0.1, 0.1, 0.8 } },
    .{ .position = .{ 0.5, -0.5, 0.5 }, .color = .{ 0.1, 0.1, 0.8 } },
    .{ .position = .{ 0.5, 0.5, 0.5 }, .color = .{ 0.1, 0.1, 0.8 } },

    .{ .position = .{ -0.5, -0.5, -0.5 }, .color = .{ 0.1, 0.8, 0.1 } },
    .{ .position = .{ 0.5, 0.5, -0.5 }, .color = .{ 0.1, 0.8, 0.1 } },
    .{ .position = .{ -0.5, 0.5, -0.5 }, .color = .{ 0.1, 0.8, 0.1 } },
    .{ .position = .{ -0.5, -0.5, -0.5 }, .color = .{ 0.1, 0.8, 0.1 } },
    .{ .position = .{ 0.5, -0.5, -0.5 }, .color = .{ 0.1, 0.8, 0.1 } },
    .{ .position = .{ 0.5, 0.5, -0.5 }, .color = .{ 0.1, 0.8, 0.1 } },
};

const vertices_t = [_]Model.Vertex{
    .{ .position = .{ -0.5, -0.5, 0.5 }, .color = .{ 0.6, 0.6, 0.3 } },
    .{ .position = .{ 0.5, 0.5, 0.5 }, .color = .{ 0.6, 0.6, 0.3 } },
    .{ .position = .{ -0.5, 0.5, 0.5 }, .color = .{ 0.6, 0.6, 0.3 } },
    .{ .position = .{ -0.5, -0.5, 0.5 }, .color = .{ 0.6, 0.6, 0.3 } },
    .{ .position = .{ 0.5, -0.5, 0.5 }, .color = .{ 0.6, 0.6, 0.3 } },
    .{ .position = .{ 0.5, 0.5, 0.5 }, .color = .{ 0.6, 0.6, 0.3 } },
};

pub fn init(
    engine: *mach.Engine.Mod,
    object: *Object.Mod,
    camera: *Camera.Mod,
    game: *Mod,
) !void {
    // const player = try engine.newEntity();

    try object.send(.init, .{});
    const model = Model.init(&vertices);

    const entt = try engine.newEntity();
    std.debug.print("ID: {d}\n", .{entt});
    try object.set(entt, .model, model);
    try object.set(entt, .transform, .{});
    try object.set(entt, .color, .{ .v = .{ 1, 1, 1 } });

    const depth_texture = core.device.createTexture(&gpu.Texture.Descriptor{
        .size = gpu.Extent3D{
            .width = core.descriptor.width,
            .height = core.descriptor.height,
        },
        .format = .depth24_plus,
        .usage = .{
            .render_attachment = true,
            .texture_binding = true,
        },
    });

    const depth_view = depth_texture.createView(&gpu.TextureView.Descriptor{
        .format = .depth24_plus,
        .dimension = .dimension_2d,
        .array_layer_count = 1,
        .mip_level_count = 1,
    });

    const main_cam = try engine.newEntity();
    try camera.send(.init, .{main_cam});
    // try camera.send(.setViewTarget, .{
    //     main_cam,
    //     math.vec3(-1, -2, -2),
    //     math.vec3(0, 0, 2.5),
    //     math.vec3(0, -1, 0),
    // });
    const aspect = @as(f32, @floatFromInt(core.descriptor.width)) / @as(f32, @floatFromInt(core.descriptor.height));
    try camera.send(.setOrthographicProjection, .{ main_cam, aspect, 0.4, -1, 1 });
    // try camera.send(.setPerspectiveProjection, .{ main_cam, math.degreesToRadians(f32, 45), aspect, 0.1, 10 });

    game.state = .{
        .title_timer = try core.Timer.start(),
        .depth_texture = depth_texture,
        .depth_view = depth_view,
        // .player = player,
    };
}

pub fn deinit(game: *Mod) !void {
    _ = game;
}

var i: f32 = 0;
pub fn tick(engine: *mach.Engine.Mod, object: *Object.Mod, game: *Mod) !void {
    var iter = core.pollEvents();
    while (iter.next()) |event| {
        switch (event) {
            .close => try engine.send(.exit, .{}),
            else => {},
        }
    }
    try engine.send(.beginPass, .{ .{ .r = 0, .g = 0, .b = 0, .a = 1 }, &.{
        .view = game.state.depth_view,
        .depth_clear_value = 1.0,
        .depth_load_op = .clear,
        .depth_store_op = .store,
    } });
    try object.set(0, .transform, .{
        // .rotation = object.get(0, .transform).?.rotation.addScalar(0.01),
        .rotation = math.vec3(object.get(0, .transform).?.rotation.x() + 0.01, 0, 0),
    });
    i += 1;
    try object.send(.render, .{1}); // TODO: 1 is camera
    try engine.send(.endPass, .{});
    try engine.send(.present, .{}); // Present the frame

    // update the window title every second
    if (game.state.title_timer.read() >= 1.0) {
        game.state.title_timer.reset();
        try core.printTitle("Triangle [ {d}fps ] [ Input {d}hz ]", .{
            core.frameRate(),
            core.inputRate(),
        });
    }
}
