const std = @import("std");
const Model = @import("Model.zig");
const Object = @import("Object.zig");
const mach = @import("mach");
const math = mach.math;
const core = mach.core;
const gpu = mach.gpu;

pub const name = .game;
pub const Mod = mach.Mod(@This());

title_timer: core.Timer,
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
    .{ .position = .{ -0.5, -0.5, 0.5 }, .color = .{ 0.1, 0.1, 0.8 } },
    .{ .position = .{ 0.5, 0.5, 0.5 }, .color = .{ 0.1, 0.1, 0.8 } },
    .{ .position = .{ -0.5, 0.5, 0.5 }, .color = .{ 0.1, 0.1, 0.8 } },
    .{ .position = .{ -0.5, -0.5, 0.5 }, .color = .{ 0.1, 0.1, 0.8 } },
    .{ .position = .{ 0.5, -0.5, 0.5 }, .color = .{ 0.1, 0.1, 0.8 } },
    .{ .position = .{ 0.5, 0.5, 0.5 }, .color = .{ 0.1, 0.1, 0.8 } },
};

pub fn init(
    engine: *mach.Engine.Mod,
    object: *Object.Mod,
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

    game.state = .{
        .title_timer = try core.Timer.start(),
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
    try engine.send(.beginPass, .{.{ .r = 0, .g = 0, .b = 0, .a = 1 }});
    try object.set(0, .transform, .{
        .rotation = object.get(0, .transform).?.rotation.addScalar(0.01),
    });
    i += 1;
    try object.send(.render, .{});
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
