const std = @import("std");
const mach = @import("mach");
const math = @import("math.zig");
const Camera = @import("Camera.zig");
const Renderer = @import("Renderer.zig");
const Object = @import("Object.zig");
const Light = @import("Light.zig");
const Model = @import("Model.zig");
const shaders = @import("shaders.zig");
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
    // We need to make sure renderer's framebuffer resize event is called before other
    .rendererFramebufferResize = .{ .handler = fn (mach.core.Size) void },
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
    try light.state().init(renderer.state());

    var prng = std.Random.DefaultPrng.init(12385);
    const random = prng.random();
    for (0..random.intRangeAtMost(u32, 10, 100)) |_| {
        // const models = &[_][]const u8{
        //     "assets/cube.m3d",
        //     "assets/dragon.m3d",
        //     "assets/monkey.m3d",
        //     "assets/torusknot.m3d",
        //     "assets/wrench.obj",
        //     "assets/sponza/Sponza.gltf",
        // };
        const kind = random.intRangeAtMost(u8, 0, 1);
        switch (kind) {
            0 => {
                // const model_index = random.intRangeAtMost(u8, 0, models.len - 1);
                // const obj = try object.newEntity();
                // const obj_model = try Model.initFromFile(models[model_index]);
                // const scale = @max(@min(random.float(f32), 1), 0.5);
                // try object.set(obj, .model, obj_model);
                // try object.set(obj, .transform, .{
                //     .translation = vec3(
                //         random.float(f32) * 10,
                //         random.float(f32),
                //         random.float(f32) * 10,
                //     ),
                //     .rotation = vec3(
                //         random.float(f32) * math.pi / 2,
                //         random.float(f32) * math.pi / 2,
                //         random.float(f32) * math.pi / 2,
                //     ),
                //     .scale = vec3(scale, scale, scale),
                // });
            },
            1 => {
                const l = try light.newEntity();
                try light.set(l, .position, vec3(
                    random.float(f32),
                    random.float(f32),
                    random.float(f32),
                ));
                try light.set(l, .color, vec4(
                    random.float(f32),
                    random.float(f32),
                    random.float(f32),
                    1,
                ));
                try light.set(l, .radius, random.float(f32) * 10);
            },
            else => unreachable,
        }
    }

    const obj2 = try object.newEntity();
    const sponza_model = try Model.initFromFile("assets/samurai.m3d");
    try object.set(obj2, .model, sponza_model);
    try object.set(obj2, .transform, .{});

    // const obj = try object.newEntity();
    // const obj_model = try Model.initFromFile("assets/cube.m3d");
    // try object.set(obj, .model, obj_model);
    // try object.set(obj, .transform, .{ .scale = vec3(50, 0.01, 50) });

    // const l = try light.newEntity();
    // try light.set(l, .position, vec3(0, 0.5, 0.7));
    // try light.set(l, .color, vec4(0, 1, 0, 1));
    // try light.set(l, .radius, 5);

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
    renderer.send(.writeCamera, .{state.main_camera});
    renderer.send(.writeLights, .{});
    object.send(.renderGBuffer, .{});
    renderer.send(.endGBuffer, .{});

    renderer.send(.beginQuad, .{});
    renderer.send(.renderQuad, .{});
    light.send(.render, .{});
    renderer.send(.endQuad, .{});

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
    state.main_camera.projection = Camera.perspective(math.pi / 4.0, w / h, 0.1, 100);

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
                    .left_bracket => {
                        const current_mode = renderer.state().render_mode;
                        const new_mode = blk: {
                            if (@intFromEnum(current_mode) + 1 > shaders.RenderMode.max) {
                                break :blk 0;
                            }
                            break :blk @intFromEnum(current_mode) + 1;
                        };
                        renderer.send(.writeRenderMode, .{@enumFromInt(new_mode)});
                    },
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
                game.sendGlobal(.rendererFramebufferResize, .{size});
                game.sendGlobal(.framebufferResize, .{size});
            },
            .close => core.send(.exit, .{}),
            else => {},
        }
    }
}
