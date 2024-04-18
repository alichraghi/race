const std = @import("std");
const mach = @import("mach");
const math = @import("math.zig");
const Camera = @import("Camera.zig");
const Object = @import("Object.zig");
const Light = @import("Light.zig");
const Model = @import("Model.zig");
const Texture = @import("Texture.zig");
const Core = mach.Core;
const gpu = mach.core.gpu;
const Mat4x4 = math.Mat4x4;
const Vec3 = math.Vec3;
const vec3 = math.vec3;
const vec4 = math.vec4;

timer: mach.core.Timer,

pass: *gpu.RenderPassEncoder,
encoder: *gpu.CommandEncoder,

depth_texture: *gpu.Texture,
depth_view: *gpu.TextureView,

wrench: mach.EntityID,
quad: mach.EntityID,
main_camera: mach.EntityID,

prev_mouse_pos: Vec3,

camera_pos: Vec3,
camera_rot: Vec3,
camera_dir: Vec3,
camera_front: Vec3,

pub const name = .game;
pub const Mod = mach.Mod(@This());

pub const global_events = .{
    .init = .{ .handler = init },
    .tick = .{ .handler = tick },
};

pub const local_events = .{
    .processEvents = .{ .handler = processEvents },
    .endFrame = .{ .handler = endFrame },
};

pub fn init(game: *Mod, camera: *Camera.Mod, object: *Object.Mod, light: *Light.Mod) !void {
    mach.core.setCursorMode(.disabled);

    // Depth Texture
    const depth_texture, const depth_view = createDepthTexture();

    // Init modules
    camera.init(.{});
    object.init(.{
        .shader = undefined,
        .camera_uniform = undefined,
        .light_uniform = undefined,
    });
    light.init(.{
        .pipeline = undefined,
        .camera_uniform_buf = undefined,
        .light_uniform_buf = undefined,
        .light_uniform_stride = undefined,
        .bind_group = undefined,
        .show_points = undefined,
    });
    try object.state().init();
    try light.state().init(10, true);

    const quad = try object.newEntity();
    const quad_model = try Model.initFromFile("assets/quad.m3d");
    object.send(.initEntity, .{ quad, 3, null });
    try object.set(quad, .model, quad_model);
    try object.set(quad, .transform, .{
        .translation = vec3(0, 0, 0),
        .scale = vec3(3, 0.01, 3),
    });

    const cube = try object.newEntity();
    const cube_model = try Model.initFromFile("assets/cube.m3d");
    object.send(.initEntity, .{ cube, 3, null });
    try object.set(cube, .model, cube_model);
    try object.set(cube, .transform, .{
        .translation = vec3(-1, 0.5, -0.5),
        .scale = vec3(0.5, 0.5, 0.5),
    });

    const wrench = try object.newEntity();
    const wrench_model = try Model.initFromFile("assets/wrench.fbx");
    object.send(.initEntity, .{ wrench, 3, null });
    try object.set(wrench, .model, wrench_model);
    try object.set(wrench, .transform, .{
        .translation = vec3(1, 0.5, 0.5),
        .rotation = vec3(0, math.pi, 0),
        .scale = vec3(0.5, 0.5, 0.5),
    });

    // Light
    const light_green = try light.newEntity();
    try light.set(light_green, .position, vec3(1, 1.5, -0.5));
    try light.set(light_green, .color, vec4(0, 1, 0, 1));
    try light.set(light_green, .radius, 0.05);

    const light_yellow = try light.newEntity();
    try light.set(light_yellow, .position, vec3(0, 1.5, 0));
    try light.set(light_yellow, .color, vec4(0.5, 0.5, 0, 1));
    try light.set(light_yellow, .radius, 0.05);

    const light_red = try light.newEntity();
    try light.set(light_red, .position, vec3(-1, 1.5, -0.5));
    try light.set(light_red, .color, vec4(1, 0, 0, 1));
    try light.set(light_red, .radius, 0.05);

    // Camera
    const main_camera = try camera.newEntity();
    try camera.set(main_camera, .projection, Mat4x4.ident);
    try camera.set(main_camera, .view, Mat4x4.ident);

    const mouse_pos = mach.core.mousePosition();
    const camera_rot = vec3(0, math.degreesToRadians(f32, 90), 0);
    const camera_front = math.worldSpaceDirection(camera_rot);

    game.init(.{
        .timer = try mach.core.Timer.start(),
        .pass = undefined,
        .encoder = mach.core.device.createCommandEncoder(&.{}),
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
    });
}

pub fn deinit(game: *Mod, object: *Object.Mod) !void {
    object.send(.deinit, .{});
    game.state().depth_texture.release();
    game.state().depth_view.release();
}

pub fn tick(game: *Mod, core: *Core.Mod, camera: *Camera.Mod, object: *Object.Mod, light: *Light.Mod) !void {
    try processEvents(game, core);

    { // Camera
        // Projection
        const aspect = @as(f32, @floatFromInt(mach.core.descriptor.width)) / @as(f32, @floatFromInt(mach.core.descriptor.height));
        try camera.set(game.state().main_camera, .projection, Camera.perspective(
            math.degreesToRadians(f32, 45),
            aspect,
            0.1,
            100,
        ));

        // Position
        const move_speed = 5 * mach.core.delta_time;
        const camera_movement =
            game.state().camera_front.mulScalar(game.state().camera_dir.z()) // Forward-Backward
            .add(&math.normalize(game.state().camera_front.cross(&math.up)).mulScalar(game.state().camera_dir.x())) // Right-Left
            .mulScalar(move_speed);
        game.state().camera_pos = game.state().camera_pos.add(&camera_movement);

        // View
        try camera.set(game.state().main_camera, .view, Camera.lookAt(
            game.state().camera_pos,
            game.state().camera_pos.add(&game.state().camera_front),
            math.up,
        ));
    }

    const back_buffer_view = mach.core.swap_chain.getCurrentTextureView().?;
    defer back_buffer_view.release();

    const color_attachment = gpu.RenderPassColorAttachment{
        .view = back_buffer_view,
        .clear_value = .{ .r = 0.09375, .g = 0.09375, .b = 0.09375, .a = 0 },
        .load_op = .clear,
        .store_op = .store,
    };
    const pass_info = gpu.RenderPassDescriptor.init(.{
        .color_attachments = &.{color_attachment},
        .depth_stencil_attachment = &.{
            .view = game.state().depth_view,
            .depth_clear_value = 1.0,
            .depth_load_op = .clear,
            .depth_store_op = .store,
        },
    });

    game.state().pass = game.state().encoder.beginRenderPass(&pass_info);

    // rotate wrench
    const transform = object.get(game.state().wrench, .transform).?;
    try object.set(game.state().wrench, .transform, .{
        .rotation = vec3(0, object.get(game.state().wrench, .transform).?.rotation.y() + 0.01, 0),
        .scale = transform.scale,
        .translation = transform.translation,
    });

    object.send(.render, .{game.state().main_camera});
    light.send(.render, .{game.state().main_camera});

    game.send(.endFrame, .{});
}

pub fn processEvents(game: *Mod, core: *Core.Mod) !void {
    var iter = mach.core.pollEvents();
    while (iter.next()) |event| {
        switch (event) {
            .key_press => |ev| {
                switch (ev.key) {
                    .w => game.state().camera_dir.v[2] += 1,
                    .d => game.state().camera_dir.v[0] += 1,
                    .s => game.state().camera_dir.v[2] -= 1,
                    .a => game.state().camera_dir.v[0] -= 1,
                    else => {},
                }
            },
            .key_release => |ev| {
                switch (ev.key) {
                    .w => game.state().camera_dir.v[2] -= 1,
                    .d => game.state().camera_dir.v[0] -= 1,
                    .s => game.state().camera_dir.v[2] += 1,
                    .a => game.state().camera_dir.v[0] += 1,
                    else => {},
                }
            },
            .mouse_motion => |m| {
                const rot_speed = mach.core.delta_time * 0.2;
                const mouse_pos = vec3(@floatCast(-m.pos.y), @floatCast(m.pos.x), 0);
                const rotation = mouse_pos.sub(&game.state().prev_mouse_pos);
                game.state().prev_mouse_pos = mouse_pos;
                game.state().camera_rot = game.state().camera_rot.add(&rotation.mulScalar(rot_speed));
                game.state().camera_front = math.worldSpaceDirection(game.state().camera_rot);
            },
            .framebuffer_resize => {
                game.state().depth_texture, game.state().depth_view = createDepthTexture();
            },
            .close => core.send(.exit, .{}),
            else => {},
        }
    }
}

pub fn endFrame(game: *Mod, core: *Core.Mod) !void {
    game.state().pass.end();
    game.state().pass.release();

    var command = game.state().encoder.finish(null);
    defer command.release();
    game.state().encoder.release();
    core.state().queue.submit(&[_]*gpu.CommandBuffer{command});

    // Prepare for next pass
    game.state().encoder = core.state().device.createCommandEncoder(&.{});
    mach.core.swap_chain.present();
}

pub fn createDepthTexture() struct { *gpu.Texture, *gpu.TextureView } {
    const texture = mach.core.device.createTexture(&gpu.Texture.Descriptor{
        .size = gpu.Extent3D{
            .width = mach.core.descriptor.width,
            .height = mach.core.descriptor.height,
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
