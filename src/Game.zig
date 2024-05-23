const std = @import("std");
const mach = @import("mach");
const math = @import("math.zig");
const Camera = @import("Camera.zig");
const Renderer = @import("Renderer.zig");
const Light = @import("Light.zig");
const Model = @import("Model.zig");
const Core = mach.Core;
const gpu = mach.gpu;
const Vec2 = math.Vec2;
const Vec3 = math.Vec3;
const vec2 = math.vec2;
const vec3 = math.vec3;
const vec4 = math.vec4;

const Game = @This();

models: std.EnumArray(ModelName, Model),

main_camera: Camera,
camera_pos: Vec3,
camera_dir: Vec3,
camera_front: Vec3,

mouse_pos: Vec2,

player: Player,

pub const name = .app;
pub const Mod = mach.Mod(Game);

pub const events = .{
    .init = .{ .handler = init },
    .deinit = .{ .handler = deinit },
    .tick = .{ .handler = tick },
    .processEvents = .{ .handler = processEvents },
    .tickCamera = .{ .handler = tickCamera },
    .framebufferResize = .{ .handler = fn (mach.core.Size) void },
};

const ModelName = enum {
    bar,
    samurai,
    cube,
};

const Player = struct {
    entity: mach.EntityID,
};

fn init(game: *Mod, renderer: *Renderer.Mod, light: *Light.Mod, core: *Core.Mod) !void {
    mach.core.setCursorMode(.disabled);

    // Init modules
    renderer.init(.{
        .limits = undefined,
        .pass = undefined,
        .encoder = undefined,
        .depth_texture = undefined,
        .depth_view = undefined,
        .shader = undefined,
        .camera_uniform = undefined,
        .lights_uniform = undefined,
        .instance_buffer = undefined,
        .sampler = undefined,
        .default_material = undefined,
    });
    light.init(.{
        .pipeline = undefined,
        .camera_uniform_buf = undefined,
        .light_uniform_buf = undefined,
        .light_uniform_stride = undefined,
        .bind_group = undefined,
    });
    game.init(.{
        .models = undefined,
        .main_camera = undefined,
        .mouse_pos = undefined,
        .camera_pos = undefined,
        .camera_dir = undefined,
        .camera_front = undefined,
        .player = undefined,
    });
    try renderer.state().init();
    try light.state().init(renderer.state());

    const state: *Game = game.state();

    // Load Models
    state.models.set(.bar, try Model.initFromFile("assets/bar.m3d"));
    state.models.set(.cube, try Model.initFromFile("assets/cube.m3d"));

    // Create Objects
    const terrain = try renderer.newEntity();
    try renderer.set(terrain, .model, state.models.get(.bar));
    try renderer.set(terrain, .transform, .{ .scale = vec3(0.1, 0.1, 0.1) });

    const cube_instanced = try renderer.newEntity();
    try renderer.set(cube_instanced, .model, state.models.get(.cube));
    try renderer.set(cube_instanced, .instances, try mach.core.allocator.dupe(Renderer.Transform, &.{
        .{
            .translation = vec3(0, 1, -2.5),
            .rotation = vec3(0, 0, 0),
            .scale = vec3(0.1, 0.1, 0.1),
        },
        .{
            .translation = vec3(2, 0, 0),
            .rotation = vec3(0, 0, 0),
            .scale = vec3(0.1, 0.1, 0.1),
        },
        .{
            .translation = vec3(5, 0, 0),
            .rotation = vec3(0, 0, 0),
            .scale = vec3(0.1, 0.1, 0.1),
        },
    }));

    // Light
    // const light_green = try light.newEntity();
    // try light.set(light_green, .position, vec3(0, 1.5, -0.5));
    // try light.set(light_green, .color, vec4(0, 1, 0, 1));
    // try light.set(light_green, .radius, 0.05);

    // const light_blue = try light.newEntity();
    // try light.set(light_blue, .position, vec3(2, 2.5, 0));
    // try light.set(light_blue, .color, vec4(0.5, 0, 1, 1));
    // try light.set(light_blue, .radius, 0.05);

    const light_red = try light.newEntity();
    try light.set(light_red, .position, vec3(-0.5, 0.2, 0));
    try light.set(light_red, .color, vec4(0, 1, 0, 1));
    try light.set(light_red, .radius, 1);

    // Camera
    state.main_camera = Camera{};
    state.camera_pos = vec3(0, 2, -1);
    state.camera_front = vec3(0.5, -0.75, 0.5);
    state.camera_dir = vec3(0, 0, 0);

    // Player
    const player_entity = try renderer.newEntity();
    try renderer.set(player_entity, .model, state.models.get(.cube));
    try renderer.set(player_entity, .transform, .{
        .scale = vec3(0.1, 0.1, 0.1),
    });
    state.player = .{ .entity = player_entity };

    // Misc
    const mouse_pos = mach.core.mousePosition();
    state.mouse_pos = vec2(@floatCast(-mouse_pos.y), @floatCast(mouse_pos.x));

    core.send(.start, .{});
}

fn deinit(game: *Mod, renderer: *Renderer.Mod, core: *Core.Mod) !void {
    const state: *Game = game.state();

    renderer.send(.deinit, .{});
    core.send(.deinit, .{});

    for (state.models.values) |model| model.deinit();
    var iter = game.entities.query(.{ .all = &.{.{ .renderer = &.{.instances} }} });
    while (iter.next()) |archetype| for (
        archetype.slice(.renderer, .instances),
    ) |instances| {
        mach.core.allocator.free(instances);
    };
}

fn tick(game: *Mod, renderer: *Renderer.Mod, light: *Light.Mod) !void {
    const state: *Game = game.state();

    game.send(.processEvents, .{});
    game.send(.tickCamera, .{});
    renderer.send(.beginRender, .{});
    renderer.send(.render, .{state.main_camera});
    light.send(.render, .{state.main_camera});
    renderer.send(.endRender, .{});
}

fn tickCamera(game: *Mod) !void {
    const state: *Game = game.state();

    // Movement
    const move_speed = 2 * mach.core.delta_time;
    const camera_movement = vec3(state.camera_front.x(), 0, state.camera_front.z()).mulScalar(state.camera_dir.z())
        .add(&math.normalize(state.camera_front.cross(&vec3(0, 1, 0))).mulScalar(state.camera_dir.x()))
        .mulScalar(move_speed);
    // const camera_movement = state.camera_front.add(&math.normalize(state.camera_front.cross(&vec3(0, 1, 0))).mul(&state.camera_dir).mulScalar(move_speed);
    state.camera_pos = state.camera_pos.add(&camera_movement);

    // Perspective Projection
    const w: f32 = @floatFromInt(mach.core.descriptor.width);
    const h: f32 = @floatFromInt(mach.core.descriptor.height);
    state.main_camera.projection = math.perspectiveRh(math.pi / 4.0, w / h, 0.01, 100);

    // Orthographic Projection
    // state.main_camera.projection = math.orthoRh(40, 40, 1, 20);

    // View
    state.main_camera.view = math.lookAtRh(
        state.camera_pos,
        state.camera_pos.add(&state.camera_front),
        math.UP,
    );
}

fn processEvents(game: *Mod, core: *Core.Mod, renderer: *Renderer.Mod) !void {
    const state: *Game = game.state();
    const renderer_state: *Renderer = renderer.state();

    var iter = mach.core.pollEvents();
    while (iter.next()) |event| {
        switch (event) {
            .key_press => |ev| {
                switch (ev.key) {
                    .w => state.camera_dir.v[2] += 1,
                    .d => state.camera_dir.v[0] += 1,
                    .s => state.camera_dir.v[2] -= 1,
                    .a => state.camera_dir.v[0] -= 1,
                    .escape => mach.core.setCursorMode(.normal),
                    else => {},
                }
            },
            .key_release => |ev| {
                switch (ev.key) {
                    .w => state.camera_dir.v[2] -= 1,
                    .d => state.camera_dir.v[0] -= 1,
                    .s => state.camera_dir.v[2] += 1,
                    .a => state.camera_dir.v[0] += 1,
                    else => {},
                }
            },
            .mouse_release => |m| switch (m.button) {
                .left => mach.core.setCursorMode(.disabled),
                else => {},
            },
            .mouse_motion => |m| {
                state.mouse_pos = vec2(@floatCast(-m.pos.y), @floatCast(m.pos.x));
            },
            .framebuffer_resize => |size| {
                renderer_state.framebufferResize(size);
            },
            .close => core.send(.exit, .{}),
            else => {},
        }
    }
}
