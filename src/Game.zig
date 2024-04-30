const std = @import("std");
const mach = @import("mach");
const math = @import("math.zig");
const Camera = @import("Camera.zig");
const Renderer = @import("Renderer.zig");
const Light = @import("Light.zig");
const Model = @import("Model.zig");
const Core = mach.Core;
const gpu = mach.gpu;
const Vec3 = math.Vec3;
const vec3 = math.vec3;
const vec4 = math.vec4;

const Game = @This();

main_camera: Camera,

prev_mouse_pos: Vec3,

camera_pos: Vec3,
camera_rot: Vec3,
camera_dir: Vec3,
camera_front: Vec3,

pub const name = .game;
pub const Mod = mach.Mod(Game);

pub const global_events = .{
    .init = .{ .handler = init },
    .tick = .{ .handler = tick },
    .framebufferResize = .{ .handler = fn (mach.core.Size) void },
};

pub const local_events = .{
    .processEvents = .{ .handler = processEvents },
    .tickCamera = .{ .handler = tickCamera },
};

fn init(game: *Mod, renderer: *Renderer.Mod, light: *Light.Mod) !void {
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
        .light_list_uniform = undefined,
        .instance_buffer = undefined,
        .material_params_uniform = undefined,
        .material_params_uniform_stride = undefined,
        .default_material = undefined,
    });
    light.init(.{
        .pipeline = undefined,
        .camera_uniform_buf = undefined,
        .light_uniform_buf = undefined,
        .light_uniform_stride = undefined,
        .bind_group = undefined,
    });
    try renderer.state().init();
    try light.state().init(renderer.state());

    // Objects
    const samurai_model = try Model.initFromFile("assets/samurai.m3d");
    const cube_model = try Model.initFromFile("assets/cube.m3d");

    const samurai = try renderer.newEntity();
    try renderer.set(samurai, .model, cube_model);
    try renderer.set(samurai, .transform, .{});

    const samurai_instanced = try renderer.newEntity();
    try renderer.set(samurai_instanced, .model, samurai_model);
    try renderer.set(samurai_instanced, .instances, try mach.core.allocator.dupe(Renderer.Transform, &.{
        .{
            .translation = vec3(0, 0, 0),
            .rotation = vec3(0, 0, 0),
            .scale = vec3(0.5, 0.5, 0.5),
        },
        .{
            .translation = vec3(2, 0, 0),
            .rotation = vec3(0, 0, 0),
            .scale = vec3(0.75, 0.75, 0.75),
        },
        .{
            .translation = vec3(5, 0, 0),
            .rotation = vec3(0, 0, 0),
            .scale = vec3(1, 1, 1),
        },
    }));

    // Light
    const light_green = try light.newEntity();
    try light.set(light_green, .position, vec3(0, 1.5, -0.5));
    try light.set(light_green, .color, vec4(0, 1, 0, 1));
    try light.set(light_green, .radius, 0.05);

    const light_blue = try light.newEntity();
    try light.set(light_blue, .position, vec3(2, 2.5, 0));
    try light.set(light_blue, .color, vec4(0.5, 0, 1, 1));
    try light.set(light_blue, .radius, 0.05);

    const light_red = try light.newEntity();
    try light.set(light_red, .position, vec3(5, 3.5, -0.5));
    try light.set(light_red, .color, vec4(1, 0, 0, 1));
    try light.set(light_red, .radius, 0.05);

    // Camera
    const main_camera = Camera{};
    const mouse_pos = mach.core.mousePosition();
    const camera_rot = vec3(0, math.pi / 2.0, 0); // 90deg
    const camera_front = math.worldSpaceDirection(camera_rot);

    game.init(.{
        .main_camera = main_camera,
        .prev_mouse_pos = vec3(@floatCast(-mouse_pos.y), @floatCast(mouse_pos.x), 0),
        .camera_pos = vec3(0, 0, -6),
        .camera_rot = camera_rot,
        .camera_dir = vec3(0, 0, 0),
        .camera_front = camera_front,
    });
}

fn deinit(game: *Mod, renderer: *Renderer.Mod) !void {
    const state: *Game = game.state();

    renderer.send(.deinit, .{});
    state.depth_texture.release();
    state.depth_view.release();
}

fn tick(game: *Mod, renderer: *Renderer.Mod, light: *Light.Mod) !void {
    const state: *Game = game.state();

    game.send(.processEvents, .{});
    game.send(.tickCamera, .{});
    renderer.send(.beginRender, .{});

    // rotate wrench
    // var trans = renderer.get(state.wrench, .transforms).?[0];
    // trans.rotation = trans.rotation.add(&vec3(0, 0.01, 0));
    // try renderer.set(state.wrench, .transforms, mach trans);

    renderer.send(.render, .{state.main_camera});
    light.send(.render, .{state.main_camera});
    renderer.send(.endRender, .{});
}

fn tickCamera(game: *Mod) !void {
    const state: *Game = game.state();

    // Position
    const move_speed = 5 * mach.core.delta_time;
    const camera_movement = state.camera_front
        .mulScalar(state.camera_dir.z()) // Forward-Backward
        .add(&math.normalize(state.camera_front.cross(&math.up)).mulScalar(state.camera_dir.x())) // Right-Left
        .mulScalar(move_speed);
    state.camera_pos = state.camera_pos.add(&camera_movement);

    // Projection
    const w: f32 = @floatFromInt(mach.core.descriptor.width);
    const h: f32 = @floatFromInt(mach.core.descriptor.height);
    state.main_camera.projection = Camera.perspective(
        math.pi / 4.0, // 45deg
        w / h,
        0.1,
        100,
    );

    // View
    state.main_camera.view = Camera.lookAt(
        state.camera_pos,
        state.camera_pos.add(&state.camera_front),
        math.up,
    );
}

fn processEvents(game: *Mod, core: *Core.Mod) !void {
    const state: *Game = game.state();

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
                const rot_speed = mach.core.delta_time * 0.2;
                const mouse_pos = vec3(@floatCast(-m.pos.y), @floatCast(m.pos.x), 0);
                const rotation = mouse_pos.sub(&state.prev_mouse_pos);
                state.prev_mouse_pos = mouse_pos;
                state.camera_rot = state.camera_rot.add(&rotation.mulScalar(rot_speed));
                state.camera_front = math.worldSpaceDirection(state.camera_rot);
            },
            .framebuffer_resize => |size| {
                game.sendGlobal(.framebufferResize, .{size});
            },
            .close => core.send(.exit, .{}),
            else => {},
        }
    }
}
