const std = @import("std");
const mach = @import("mach");
const core = mach.core;
const Engine = mach.Engine;
const gpu = core.gpu;
const math = mach.math;
const zm = @import("zmath.zig");
const Camera = @import("Camera.zig");
const Object = @import("Object.zig");
const Model = @import("Model.zig");
const vec3 = math.vec3;

timer: core.Timer,
depth_texture: *gpu.Texture,
depth_view: *gpu.TextureView,
cube: mach.ecs.EntityID,
plane: mach.ecs.EntityID,
camera: Camera,

pub const name = .game;
pub const Mod = mach.Mod(@This());

pub fn init(engine: *Engine.Mod, object: *Object.Mod, game: *Mod) !void {
    _ = engine;

    core.setCursorMode(.disabled);

    try object.send(.init, .{});

    const plane = try object.newEntity();
    const plane_model = Model.init(&cube_vertices);
    try object.set(plane, .model, plane_model);
    try object.set(plane, .transform, .{
        .translation = vec3(0, -1, 0),
        .scale = vec3(3, 0.01, 3),
    });
    try object.set(plane, .color, vec3(1, 1, 1));

    const cube = try object.newEntity();
    const cube_model = Model.init(&cube_vertices);
    try object.set(cube, .model, cube_model);
    try object.set(cube, .transform, .{});
    try object.set(cube, .color, vec3(1, 1, 1));

    const camera = Camera.init();

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

    const m_pos = core.mousePosition();
    const screen_size = vec3(@floatFromInt(core.descriptor.height), 0, @floatFromInt(core.descriptor.width));
    const screen_mid = screen_size.divScalar(2);
    old_mouse_pos = vec3(@floatCast(-m_pos.y), @floatCast(m_pos.x), 0).sub(&screen_mid);
    const rot_speed = 0.1;
    camera_rot = camera_rot.add(&old_mouse_pos.mulScalar(core.delta_time * rot_speed));
    camera_front = normalize(vec3(
        @cos(camera_rot.y()) * @cos(camera_rot.x()),
        @sin(camera_rot.x()),
        @sin(camera_rot.y()) * @cos(camera_rot.x()),
    ));

    game.state = .{
        .timer = try core.Timer.start(),
        .cube = cube,
        .plane = plane,
        .camera = camera,
        .depth_texture = depth_texture,
        .depth_view = depth_view,
    };
}

pub fn deinit(game: *Mod) !void {
    _ = game;
}

var camera_pos = vec3(0, 0, -6);
var camera_rot = vec3(0, math.degreesToRadians(f32, 90), 0);
var camera_pos_dir = vec3(0, 0, 0);
var old_mouse_pos = vec3(0, 0, 0);
const camera_up = vec3(0, 1, 0);
var camera_front = vec3(0, 0, 1);

pub fn tick(engine: *Engine.Mod, object: *Object.Mod, game: *Mod) !void {
    const move_speed = 5 * core.delta_time;
    var iter = core.pollEvents();
    while (iter.next()) |event| {
        switch (event) {
            .key_press => |ev| {
                switch (ev.key) {
                    .w => camera_pos_dir.v[2] += 1,
                    .s => camera_pos_dir.v[2] -= 1,
                    .a => camera_pos_dir.v[0] -= 1,
                    .d => camera_pos_dir.v[0] += 1,
                    else => {},
                }
            },
            .key_release => |ev| {
                switch (ev.key) {
                    .w => camera_pos_dir.v[2] -= 1,
                    .s => camera_pos_dir.v[2] += 1,
                    .a => camera_pos_dir.v[0] += 1,
                    .d => camera_pos_dir.v[0] -= 1,
                    else => {},
                }
            },
            .mouse_motion => |m| {
                const screen_size = vec3(@floatFromInt(core.descriptor.height), 0, @floatFromInt(core.descriptor.width));
                const screen_mid = screen_size.divScalar(2);
                const new_mouse_pos = vec3(@floatCast(-m.pos.y), @floatCast(m.pos.x), 0).sub(&screen_mid);
                const rotation = new_mouse_pos.sub(&old_mouse_pos);
                old_mouse_pos = new_mouse_pos;

                const rot_speed = 0.1;
                camera_rot = camera_rot.add(&rotation.mulScalar(core.delta_time * rot_speed));

                camera_front = normalize(vec3(
                    @cos(camera_rot.y()) * @cos(camera_rot.x()),
                    @sin(camera_rot.x()),
                    @sin(camera_rot.y()) * @cos(camera_rot.x()),
                ));
            },
            .close => try engine.send(.exit, .{}),
            else => {},
        }
    }

    const aspect = @as(f32, @floatFromInt(core.descriptor.width)) / @as(f32, @floatFromInt(core.descriptor.height));
    game.state.camera.perspectiveFovy(
        math.degreesToRadians(f32, 45),
        aspect,
        0.1,
        100,
    );
    // game.state.camera.orthographicProjection(
    //     -aspect,
    //     aspect,
    //     1,
    //     -1,
    //     -1,
    //     1,
    // );

    if (camera_pos_dir.z() == 1) {
        camera_pos = camera_pos.add(&camera_front.mulScalar(move_speed));
    } else if (camera_pos_dir.z() == -1) {
        camera_pos = camera_pos.sub(&camera_front.mulScalar(move_speed));
    }

    if (camera_pos_dir.x() == 1) {
        camera_pos = camera_pos.add(&normalize(camera_front.cross(&camera_up)).mulScalar(move_speed));
    } else if (camera_pos_dir.x() == -1) {
        camera_pos = camera_pos.sub(&normalize(camera_front.cross(&camera_up)).mulScalar(move_speed));
    }
    std.debug.print("{d}\n", .{camera_front.v});

    game.state.camera.lookAt(camera_pos, camera_pos.add(&camera_front), camera_up);

    try engine.send(.beginPass, .{ std.mem.zeroes(gpu.Color), &.{
        .view = game.state.depth_view,
        .depth_clear_value = 1.0,
        .depth_load_op = .clear,
        .depth_store_op = .store,
    } });

    try object.set(game.state.cube, .transform, .{
        // .rotation = object.get(game.state.cube, .transform).?.rotation.addScalar(0.01),
    });
    try object.send(.render, .{game.state.camera});

    try engine.send(.endPass, .{});
    try engine.send(.present, .{});
}

fn normalize(v: math.Vec3) math.Vec3 {
    return v.mulScalar(1 / v.len());
}

pub const cube_vertices = [_]Model.Vertex{
    .{ .position = .{ 1, -1, 1 }, .color = .{ 1, 0, 1 } },
    .{ .position = .{ -1, -1, 1 }, .color = .{ 0, 0, 1 } },
    .{ .position = .{ -1, -1, -1 }, .color = .{ 1, 1, 1 } },
    .{ .position = .{ 1, -1, -1 }, .color = .{ 1, 0, 0 } },
    .{ .position = .{ 1, -1, 1 }, .color = .{ 1, 0, 1 } },
    .{ .position = .{ -1, -1, -1 }, .color = .{ 1, 1, 1 } },

    .{ .position = .{ 1, 1, 1 }, .color = .{ 1, 1, 1 } },
    .{ .position = .{ 1, -1, 1 }, .color = .{ 1, 0, 1 } },
    .{ .position = .{ 1, -1, -1 }, .color = .{ 1, 0, 0 } },
    .{ .position = .{ 1, 1, -1 }, .color = .{ 1, 1, 0 } },
    .{ .position = .{ 1, 1, 1 }, .color = .{ 1, 1, 1 } },
    .{ .position = .{ 1, -1, -1 }, .color = .{ 1, 0, 0 } },

    .{ .position = .{ -1, 1, 1 }, .color = .{ 0, 1, 1 } },
    .{ .position = .{ 1, 1, 1 }, .color = .{ 1, 1, 1 } },
    .{ .position = .{ 1, 1, -1 }, .color = .{ 1, 1, 0 } },
    .{ .position = .{ -1, 1, -1 }, .color = .{ 0, 1, 0 } },
    .{ .position = .{ -1, 1, 1 }, .color = .{ 0, 1, 1 } },
    .{ .position = .{ 1, 1, -1 }, .color = .{ 1, 1, 0 } },

    .{ .position = .{ -1, -1, 1 }, .color = .{ 0, 0, 1 } },
    .{ .position = .{ -1, 1, 1 }, .color = .{ 0, 1, 1 } },
    .{ .position = .{ -1, 1, -1 }, .color = .{ 0, 1, 0 } },
    .{ .position = .{ -1, -1, -1 }, .color = .{ 1, 1, 1 } },
    .{ .position = .{ -1, -1, 1 }, .color = .{ 0, 0, 1 } },
    .{ .position = .{ -1, 1, -1 }, .color = .{ 0, 1, 0 } },

    .{ .position = .{ 1, 1, 1 }, .color = .{ 1, 1, 1 } },
    .{ .position = .{ -1, 1, 1 }, .color = .{ 0, 1, 1 } },
    .{ .position = .{ -1, -1, 1 }, .color = .{ 0, 0, 1 } },
    .{ .position = .{ -1, -1, 1 }, .color = .{ 0, 0, 1 } },
    .{ .position = .{ 1, -1, 1 }, .color = .{ 1, 0, 1 } },
    .{ .position = .{ 1, 1, 1 }, .color = .{ 1, 1, 1 } },

    .{ .position = .{ 1, -1, -1 }, .color = .{ 1, 0, 0 } },
    .{ .position = .{ -1, -1, -1 }, .color = .{ 1, 1, 1 } },
    .{ .position = .{ -1, 1, -1 }, .color = .{ 0, 1, 0 } },
    .{ .position = .{ 1, 1, -1 }, .color = .{ 1, 1, 0 } },
    .{ .position = .{ 1, -1, -1 }, .color = .{ 1, 0, 0 } },
    .{ .position = .{ -1, 1, -1 }, .color = .{ 0, 1, 0 } },
};

const plane_vertices = [_]Model.Vertex{
    .{ .position = .{ 1, -1, -1 }, .color = .{ 1, 0, 0 } },
    .{ .position = .{ -1, -1, -1 }, .color = .{ 1, 1, 1 } },
    .{ .position = .{ -1, 1, -1 }, .color = .{ 0, 1, 0 } },
    .{ .position = .{ 1, 1, -1 }, .color = .{ 1, 1, 0 } },
    .{ .position = .{ 1, -1, -1 }, .color = .{ 1, 0, 0 } },
    .{ .position = .{ -1, 1, -1 }, .color = .{ 0, 1, 0 } },
};
