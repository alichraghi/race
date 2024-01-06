const std = @import("std");
const mach = @import("mach");
const math = @import("math.zig");
const Camera = @import("Camera.zig");
const Object = @import("Object.zig");
const Light = @import("Light.zig");
const Model = @import("Model.zig");
const core = mach.core;
const Engine = mach.Engine;
const gpu = core.gpu;
const Mat4x4 = math.Mat4x4;
const Vec3 = math.Vec3;
const vec3 = math.vec3;
const vec4 = math.vec4;

timer: core.Timer,

depth_texture: *gpu.Texture,
depth_view: *gpu.TextureView,

wrench: mach.ecs.EntityID,
quad: mach.ecs.EntityID,
main_camera: mach.ecs.EntityID,

prev_mouse_pos: Vec3,

camera_pos: Vec3,
camera_rot: Vec3,
camera_dir: Vec3,
camera_front: Vec3,

pub const name = .game;
pub const Mod = mach.Mod(@This());

pub fn init(game: *Mod, camera: *Camera.Mod, object: *Object.Mod, light: *Light.Mod) !void {
    core.setCursorMode(.disabled);

    // Depth Texture
    const depth_texture, const depth_view = createDepthTexture();

    // Init modules
    try camera.send(.init, .{});
    try object.send(.init, .{10});
    try light.send(.init, .{ 10, true });

    const quad = try object.newEntity();
    const quad_model = try Model.initFromFile("assets/quad.m3d");
    try object.set(quad, .model, quad_model);
    try object.set(quad, .transform, .{
        .translation = vec3(0, 0, 0),
        .scale = vec3(3, 0.01, 3),
    });

    const cube = try object.newEntity();
    const cube_model = try Model.initFromFile("assets/cube.m3d");
    try object.set(cube, .model, cube_model);
    try object.set(cube, .transform, .{
        .translation = vec3(-1, 0.5, -0.5),
        .scale = vec3(0.5, 0.5, 0.5),
    });

    const wrench = try object.newEntity();
    const wrench_model = try Model.initFromFile("assets/wrench.fbx");
    try object.set(wrench, .model, wrench_model);
    try object.set(wrench, .transform, .{
        .translation = vec3(1, 0.5, 0.5),
        .rotation = vec3(0, math.pi, 0),
        .scale = vec3(0.5, 0.5, 0.5),
    });

    // Light
    const light_red = try light.newEntity();
    try light.set(light_red, .position, vec3(1, 1.5, 0));
    try light.set(light_red, .color, vec4(0, 1, 0, 1));
    try light.set(light_red, .radius, 0.05);

    const light_green = try light.newEntity();
    try light.set(light_green, .position, vec3(-1, 1.5, 0));
    try light.set(light_green, .color, vec4(1, 0, 0, 1));
    try light.set(light_green, .radius, 0.05);

    const light_blue = try light.newEntity();
    try light.set(light_blue, .position, vec3(0, 1.5, -1));
    try light.set(light_blue, .color, vec4(0, 0, 1, 1));
    try light.set(light_blue, .radius, 0.05);

    // Camera
    const main_camera = try camera.newEntity();
    try camera.set(main_camera, .projection, Mat4x4.ident);
    try camera.set(main_camera, .view, Mat4x4.ident);

    const mouse_pos = core.mousePosition();
    const camera_rot = vec3(0, math.degreesToRadians(f32, 90), 0);
    const camera_front = math.worldSpaceDirection(camera_rot);

    game.state = .{
        .timer = try core.Timer.start(),
        .depth_texture = depth_texture,
        .depth_view = depth_view,
        .wrench = wrench,
        .quad = quad,
        .main_camera = main_camera,
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
}

pub fn tick(game: *Mod, engine: *Engine.Mod, camera: *Camera.Mod, object: *Object.Mod, light: *Light.Mod) !void {
    try game.send(.processEvents, .{});

    { // Camera
        // Projection
        const aspect = @as(f32, @floatFromInt(core.descriptor.width)) / @as(f32, @floatFromInt(core.descriptor.height));
        try camera.send(.perspective, .{
            game.state.main_camera,
            math.degreesToRadians(f32, 45),
            aspect,
            0.1,
            100,
        });

        // Position
        const move_speed = 5 * core.delta_time;
        const camera_movement =
            game.state.camera_front.mulScalar(game.state.camera_dir.z()) // Forward-Backward
            .add(&math.normalize(game.state.camera_front.cross(&math.up)).mulScalar(game.state.camera_dir.x())) // Right-Left
            .mulScalar(move_speed);
        game.state.camera_pos = game.state.camera_pos.add(&camera_movement);

        // View
        try camera.send(.lookAt, .{
            game.state.main_camera,
            game.state.camera_pos,
            game.state.camera_pos.add(&game.state.camera_front),
            math.up,
        });
    }

    try engine.send(.beginPass, .{ .{ .r = 0.09375, .g = 0.09375, .b = 0.09375, .a = 0 }, &.{
        .view = game.state.depth_view,
        .depth_clear_value = 1.0,
        .depth_load_op = .clear,
        .depth_store_op = .store,
    } });

    // try object.set(game.state.wrench, .transform, .{
    //     .rotation = vec3(0, object.get(game.state.wrench, .transform).?.rotation.y() + 0.01, 0),
    // });
    try object.send(.render, .{game.state.main_camera});
    try light.send(.render, .{game.state.main_camera});

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
                .framebuffer_resize => {
                    game.state.depth_texture, game.state.depth_view = createDepthTexture();
                },
                .close => try engine.send(.exit, .{}),
                else => {},
            }
        }
    }
};

pub fn createDepthTexture() struct { *gpu.Texture, *gpu.TextureView } {
    const texture = core.device.createTexture(&gpu.Texture.Descriptor{
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

    const view = texture.createView(&gpu.TextureView.Descriptor{
        .format = .depth24_plus,
        .dimension = .dimension_2d,
        .array_layer_count = 1,
        .mip_level_count = 1,
    });

    return .{ texture, view };
}
