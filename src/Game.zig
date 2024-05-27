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
camera_rot: Vec3,
camera_dir: Vec3,
camera_front: Vec3,

pub const name = .app;
pub const Mod = mach.Mod(Game);

pub const systems = .{
    .init = .{ .handler = init },
    .deinit = .{ .handler = deinit },
    .tick = .{ .handler = tick },
    .processEvents = .{ .handler = processEvents },
    .initScene = .{ .handler = initScene },
    .tickCamera = .{ .handler = tickCamera },
};

pub fn init(
    game: *Mod,
    object: *Object.Mod,
    renderer: *Renderer.Mod,
    light: *Light.Mod,
    core: *Core.Mod,
) !void {

    // Init modules
    renderer.init(.{});
    object.init(.{});
    light.init(.{});
    core.schedule(.init);
    renderer.schedule(.init);
    light.schedule(.init);

    // Camera
    const main_camera = Camera{};
    const camera_rot = vec3(0, math.pi / 2.0, 0); // 90deg
    const camera_front = math.worldSpaceDirection(camera_rot);
    const mouse_pos = mach.core.mousePosition();

    game.init(.{
        .main_camera = main_camera,
        .prev_mouse_pos = vec3(@floatCast(-mouse_pos.y), @floatCast(mouse_pos.x), 0),
        .camera_rot = camera_rot,
        .camera_dir = vec3(0, 0, 0),
        .camera_front = camera_front,
    });

    game.schedule(.initScene);

    core.schedule(.start);
}

pub fn initScene(object: *Object.Mod, light: *Light.Mod, entities: *mach.Entities.Mod) !void {
    mach.core.setCursorMode(.disabled);

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
                // const l = try light.newEntity();
                // try light.set(l, .position, vec3(
                //     random.float(f32),
                //     random.float(f32),
                //     random.float(f32),
                // ));
                // try light.set(l, .color, vec4(
                //     random.float(f32),
                //     random.float(f32),
                //     random.float(f32),
                //     1,
                // ));
                // try light.set(l, .radius, random.float(f32) * 10);
            },
            else => unreachable,
        }
    }

    const obj2 = try entities.new();
    const sponza_model = try Model.initFromFile("assets/bar.m3d");
    try object.set(obj2, .model, sponza_model);
    try object.set(obj2, .transform, .{});

    const obj = try entities.new();
    const obj_model = try Model.initFromFile("assets/cube_normals.m3d");
    try object.set(obj, .model, obj_model);
    try object.set(obj, .transform, .{ .scale = vec3(0.1, 0.1, 0.1) });

    const l = try entities.new();
    try light.set(l, .position, vec3(-10, 3, -4));
    try light.set(l, .color, vec4(0, 0, 1, 1));
    try light.set(l, .radius, 2);

    const l2 = try entities.new();
    try light.set(l2, .position, vec3(0, 0.5, 0));
    try light.set(l2, .color, vec4(1, 1, 1, 1));
    try light.set(l2, .radius, 2);
}

pub fn deinit(core: *Core.Mod) !void {
    core.schedule(.deinit);
}

pub fn tick(game: *Mod, renderer: *Renderer.Mod) !void {
    const state: *Game = game.state();

    game.schedule(.processEvents);
    game.schedule(.tickCamera);

    renderer.scheduleWithArgs(.render, .{state.main_camera});
}

pub fn tickCamera(game: *Mod) !void {
    const state: *Game = game.state();

    // Position
    const move_speed = 5 * mach.core.delta_time;
    const camera_movement = state.camera_front
        .mulScalar(state.camera_dir.z()) // Forward-Backward
        .add(&math.normalize(state.camera_front.cross(&math.up)).mulScalar(state.camera_dir.x())) // Right-Left
        .mulScalar(move_speed);
    state.main_camera.position = state.main_camera.position.add(&camera_movement);

    // Projection
    const w: f32 = @floatFromInt(mach.core.descriptor.width);
    const h: f32 = @floatFromInt(mach.core.descriptor.height);
    state.main_camera.projection = Camera.perspective(math.pi / 4.0, w / h, 0.1, 100);

    // View
    state.main_camera.view = Camera.lookAt(
        state.main_camera.position,
        state.main_camera.position.add(&state.camera_front),
        math.up,
    );
}

pub fn processEvents(game: *Mod, renderer: *Renderer.Mod, core: *Core.Mod) !void {
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
                    .left_bracket => {
                        const current_mode = renderer.state().render_mode;
                        const new_mode = blk: {
                            if (@intFromEnum(current_mode) + 1 > shaders.RenderMode.max) {
                                break :blk 0;
                            }
                            break :blk @intFromEnum(current_mode) + 1;
                        };
                        renderer_state.render_mode = @enumFromInt(new_mode);
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
                renderer.scheduleWithArgs(.framebufferResize, .{size});
            },
            .close => core.schedule(.exit),
            else => {},
        }
    }
}
