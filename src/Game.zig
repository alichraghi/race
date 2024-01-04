const std = @import("std");
const mach = @import("mach");
const math = @import("math.zig");
const mesh = @import("mesh.zig");
const Camera = @import("Camera.zig");
const Object = @import("Object.zig");
const Light = @import("Light.zig");
const Model = @import("Model.zig");
const core = mach.core;
const Engine = mach.Engine;
const gpu = core.gpu;
const Vec3 = math.Vec3;
const vec3 = math.vec3;
const vec4 = math.vec4;

timer: core.Timer,

depth_texture: *gpu.Texture,
depth_view: *gpu.TextureView,

dragon: mach.ecs.EntityID,
quad: mach.ecs.EntityID,

prev_mouse_pos: Vec3,

camera: Camera,
camera_pos: Vec3,
camera_rot: Vec3,
camera_dir: Vec3,
camera_front: Vec3,

pub const name = .game;
pub const Mod = mach.Mod(@This());

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn init(game: *Mod, object: *Object.Mod, light: *Light.Mod) !void {
    core.setCursorMode(.disabled);

    // Depth Texture
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

    // Init modules
    try object.send(.init, .{10});
    try light.send(.init, .{10});

    const quad_m3d = try std.fs.cwd().openFile("assets/quad.m3d", .{});
    defer quad_m3d.close();
    const quad_data = try quad_m3d.readToEndAllocOptions(allocator, 1024 * 1024 * 1024, null, @alignOf(u8), 0);
    defer allocator.free(quad_data);

    const quad = try object.newEntity();
    const quad_model = try Model.initFromM3D(allocator, quad_data);
    try object.set(quad, .model, quad_model);
    try object.set(quad, .transform, .{
        .translation = vec3(0, -1, 0),
        .scale = vec3(3, 0, 3),
    });

    const cube_m3d = try std.fs.cwd().openFile("assets/cube.m3d", .{});
    defer cube_m3d.close();
    const cube_data = try cube_m3d.readToEndAllocOptions(allocator, 1024 * 1024 * 1024, null, @alignOf(u8), 0);
    defer allocator.free(cube_data);

    const cube = try object.newEntity();
    const cube_model = try Model.initFromM3D(allocator, cube_data);
    try object.set(cube, .model, cube_model);
    try object.set(cube, .transform, .{
        .translation = vec3(1, 0.5, 0),
        .scale = vec3(0.5, 0.5, 0.5),
    });

    const dragon_m3d = try std.fs.cwd().openFile("assets/monkey.m3d", .{});
    defer dragon_m3d.close();
    const dragon_data = try dragon_m3d.readToEndAllocOptions(allocator, 1024 * 1024 * 1024, null, @alignOf(u8), 0);
    defer allocator.free(dragon_data);

    const dragon = try object.newEntity();
    const dragon_model = try Model.initFromM3D(allocator, dragon_data);
    try object.set(dragon, .model, dragon_model);
    try object.set(dragon, .transform, .{
        .translation = vec3(0, 1, 0),
        .rotation = vec3(0, math.pi, 0),
        .scale = vec3(0.5, 0.5, 0.5),
    });

    // Light
    const light_0 = try light.newEntity();
    try light.set(light_0, .position, vec3(0.5, 0.75, 0));
    try light.set(light_0, .color, vec4(0, 1, 0, 1));

    // Camera
    const camera = Camera.init();

    const mouse_pos = core.mousePosition();
    const camera_rot = vec3(0, math.degreesToRadians(f32, 90), 0);
    const camera_front = math.worldSpaceDirection(camera_rot);

    game.state = .{
        .timer = try core.Timer.start(),
        .depth_texture = depth_texture,
        .depth_view = depth_view,
        .dragon = dragon,
        .quad = quad,
        .camera = camera,
        .prev_mouse_pos = vec3(@floatCast(-mouse_pos.y), @floatCast(mouse_pos.x), 0),
        .camera_pos = vec3(0, 0, -6),
        .camera_rot = camera_rot,
        .camera_dir = vec3(0, 0, 0),
        .camera_front = camera_front,
    };
}

pub fn deinit(game: *Mod, object: *Object.Mod) !void {
    try object.send(.deinit, .{});
    game.state.depth_texture.release();
    game.state.depth_view.release();
    _ = gpa.deinit();
}

pub fn tick(game: *Mod, engine: *Engine.Mod, object: *Object.Mod, light: *Light.Mod) !void {
    try game.send(.processEvents, .{});

    { // Camera
        // Projection
        const aspect = @as(f32, @floatFromInt(core.descriptor.width)) / @as(f32, @floatFromInt(core.descriptor.height));
        game.state.camera.perspective(
            math.degreesToRadians(f32, 45),
            aspect,
            0.1,
            100,
        );

        // Position
        const move_speed = 5 * core.delta_time;
        const camera_movement =
            game.state.camera_front.mulScalar(game.state.camera_dir.z()) // Forward-Backward
            .add(&math.normalize(game.state.camera_front.cross(&math.up)).mulScalar(game.state.camera_dir.x())) // Right-Left
            .mulScalar(move_speed);
        game.state.camera_pos = game.state.camera_pos.add(&camera_movement);

        // View
        game.state.camera.lookAt(
            game.state.camera_pos,
            game.state.camera_pos.add(&game.state.camera_front),
            math.up,
        );
    }

    try engine.send(.beginPass, .{ .{ .r = 0.09375, .g = 0.09375, .b = 0.09375, .a = 0 }, &.{
        .view = game.state.depth_view,
        .depth_clear_value = 1.0,
        .depth_load_op = .clear,
        .depth_store_op = .store,
    } });

    // try object.set(game.state.dragon, .transform, .{
    //     .rotation = vec3(0, object.get(game.state.dragon, .transform).?.rotation.y() + 0.01, 0),
    // });
    try object.send(.render, .{game.state.camera});
    try light.send(.render, .{game.state.camera});

    try engine.send(.endPass, .{});
    try engine.send(.present, .{});
}

pub const local = struct {
    pub fn processEvents(game: *Mod, engine: *Engine.Mod) !void {
        var iter = core.pollEvents();
        while (iter.next()) |event| {
            switch (event) {
                .key_press => |ev| {
                    switch (ev.key) {
                        .w => game.state.camera_dir.v[2] += 1,
                        .d => game.state.camera_dir.v[0] += 1,
                        .s => game.state.camera_dir.v[2] -= 1,
                        .a => game.state.camera_dir.v[0] -= 1,
                        else => {},
                    }
                },
                .key_release => |ev| {
                    switch (ev.key) {
                        .w => game.state.camera_dir.v[2] -= 1,
                        .d => game.state.camera_dir.v[0] -= 1,
                        .s => game.state.camera_dir.v[2] += 1,
                        .a => game.state.camera_dir.v[0] += 1,
                        else => {},
                    }
                },
                .mouse_motion => |m| {
                    const rot_speed = core.delta_time * 0.2;
                    const mouse_pos = vec3(@floatCast(-m.pos.y), @floatCast(m.pos.x), 0);
                    const rotation = mouse_pos.sub(&game.state.prev_mouse_pos);
                    game.state.prev_mouse_pos = mouse_pos;
                    game.state.camera_rot = game.state.camera_rot.add(&rotation.mulScalar(rot_speed));
                    game.state.camera_front = math.worldSpaceDirection(game.state.camera_rot);
                },
                .close => try engine.send(.exit, .{}),
                else => {},
            }
        }
    }
};
