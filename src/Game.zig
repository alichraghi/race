const std = @import("std");
const mach = @import("mach");
const math = @import("math.zig");
const Camera = @import("Camera.zig");
const Renderer = @import("Renderer.zig");
const Object = @import("Object.zig");
const Light = @import("Light.zig");
const Model = @import("Model.zig");
const Core = mach.Core;
const gpu = mach.gpu;
const Vec3 = math.Vec3;
const vec3 = math.vec3;
const vec4 = math.vec4;

const Game = @This();

main_camera: Camera,
wrench: mach.EntityID,
quad: mach.EntityID,

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

pub fn init(game: *Mod, object: *Object.Mod, renderer: *Renderer.Mod, light: *Light.Mod) !void {
    mach.core.setCursorMode(.disabled);

    // Init modules
    renderer.init(.{});
    object.init(.{});
    light.init(.{});
    try renderer.state().init();
    try object.state().init();
    try light.state().init(object.state());

    // Objects
    const quad = try object.newEntity();
    const quad_model = try Model.initFromFile("assets/cube.m3d");
    try object.set(quad, .texture, null);
    try object.set(quad, .model, quad_model);
    try object.set(quad, .transform, .{ .scale = vec3(3, 0.0001, 3) });

    // const cube = try object.newEntity();
    // const cube_model = try Model.initFromFile("assets/cube.m3d");
    // try object.set(cube, .texture, null);
    // try object.set(cube, .model, cube_model);
    // try object.set(cube, .transform, .{ .scale = vec3(0.5, 0.5, 0.5) });

    const wrench = try object.newEntity();
    const wrench_model = try Model.initFromFile("assets/torusknot.m3d");
    try object.set(wrench, .texture, null);
    try object.set(wrench, .model, wrench_model);
    try object.set(wrench, .instances, try mach.core.allocator.dupe(Object.Transform, &.{
        // .{
        //     .translation = vec3(0, 0, 0),
        //     .rotation = vec3(0, 0, 0),
        //     .scale = vec3(0.5, 0.5, 0.5),
        // },
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
    try light.set(light_green, .position, vec3(0, 0.5, -0.5));
    try light.set(light_green, .color, vec4(0, 1, 0, 1));
    try light.set(light_green, .radius, 5);

    const light_blue = try light.newEntity();
    try light.set(light_blue, .position, vec3(2, 0.5, 0));
    try light.set(light_blue, .color, vec4(0.5, 0, 1, 1));
    try light.set(light_blue, .radius, 5);

    const light_red = try light.newEntity();
    try light.set(light_red, .position, vec3(5, 0.5, -0.5));
    try light.set(light_red, .color, vec4(1, 0, 0, 1));
    try light.set(light_red, .radius, 5);

    // Camera
    const main_camera = Camera{};
    const mouse_pos = mach.core.mousePosition();
    const camera_rot = vec3(0, math.pi / 2.0, 0); // 90deg
    const camera_front = math.worldSpaceDirection(camera_rot);

    game.init(.{
        .main_camera = main_camera,
        .wrench = wrench,
        .quad = quad,
        .prev_mouse_pos = vec3(@floatCast(-mouse_pos.y), @floatCast(mouse_pos.x), 0),
        .camera_pos = vec3(0, 0, -6),
        .camera_rot = camera_rot,
        .camera_dir = vec3(0, 0, 0),
        .camera_front = camera_front,
    });
}

pub fn deinit(game: *Mod, object: *Object.Mod) !void {
    const state: *Game = game.state();

    object.send(.deinit, .{});
    state.depth_texture.release();
    state.depth_view.release();
}

pub fn tick(game: *Mod, renderer: *Renderer.Mod, object: *Object.Mod, light: *Light.Mod) !void {
    const state: *Game = game.state();

    game.send(.processEvents, .{});
    game.send(.tickCamera, .{});
    renderer.send(.record, .{});

    renderer.send(.beginGBuffer, .{});
    object.send(.renderGBuffer, .{state.main_camera});
    renderer.send(.endGBuffer, .{});

    renderer.send(.beginDeferred, .{});
    object.send(.render, .{});
    light.send(.render, .{state.main_camera});
    renderer.send(.endDeferred, .{});

    renderer.send(.submit, .{});
}

pub fn tickCamera(game: *Mod) !void {
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

pub fn processEvents(game: *Mod, renderer: *Renderer.Mod, core: *Core.Mod) !void {
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
                // renderer.state().depth_texture, renderer.state().depth_view = Renderer.createDepthTexture();
                // TODO: for some reason, this produces weird results
                _ = &renderer;
                game.sendGlobal(.framebufferResize, .{size});
            },
            .close => core.send(.exit, .{}),
            else => {},
        }
    }
}
