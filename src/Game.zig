const std = @import("std");
const mach = @import("mach");
const core = mach.core;
const Engine = mach.Engine;
const gpu = core.gpu;
const zm = @import("zmath.zig");
const math = mach.math;
const Vec = zm.Vec;
const Mat = zm.Mat;
const Quat = zm.Quat;
const vec4 = math.vec4;
const Vec3 = math.Vec3;
const vec3 = math.vec3;
const mat4x4 = math.mat4x4;
const Mat4x4 = math.Mat4x4;

pub const name = .game;
pub const Mod = mach.Mod(@This());

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

title_timer: core.Timer,
timer: core.Timer,
cube: Cube,
camera: Camera,
light: Light,
depth: Texture,
keys: u8,

pub fn init(engine: *mach.Engine.Mod, game: *Mod) !void {
    _ = engine;
    const eye = vec3(5.0, 7.0, 5.0);
    const target = vec3(0.0, 0.0, 0.0);

    const framebuffer = core.descriptor;
    const aspect_ratio = @as(f32, @floatFromInt(framebuffer.width)) / @as(f32, @floatFromInt(framebuffer.height));

    game.state = .{
        .title_timer = try core.Timer.start(),
        .timer = try core.Timer.start(),
        .cube = Cube.init(),
        .light = Light.init(),
        .depth = Texture.depth(core.device, framebuffer.width, framebuffer.height),
        .camera = Camera.init(
            core.device,
            eye,
            target,
            vec3(0.0, 1.0, 0.0),
            aspect_ratio,
            45.0,
            0.1,
            100.0,
        ),
        .keys = 0,
    };
}

pub fn deinit(game: *Mod) !void {
    game.state.cube.deinit();
    game.state.camera.deinit();
    game.state.light.deinit();
    game.state.depth.release();
    _ = gpa.deinit();
}

pub fn tick(engine: *Engine.Mod, game: *Mod) !void {
    const delta_time = game.state.timer.lap();

    var iter = core.pollEvents();
    while (iter.next()) |event| {
        switch (event) {
            .key_press => |ev| switch (ev.key) {
                .q, .escape, .space => try engine.send(.exit, .{}),
                .w, .up => {
                    game.state.keys |= Dir.up;
                },
                .s, .down => {
                    game.state.keys |= Dir.down;
                },
                .a, .left => {
                    game.state.keys |= Dir.left;
                },
                .d, .right => {
                    game.state.keys |= Dir.right;
                },
                .one => core.setDisplayMode(.windowed, null),
                .two => core.setDisplayMode(.fullscreen, null),
                .three => core.setDisplayMode(.borderless, null),
                else => {},
            },
            .key_release => |ev| switch (ev.key) {
                .w, .up => {
                    game.state.keys &= ~Dir.up;
                },
                .s, .down => {
                    game.state.keys &= ~Dir.down;
                },
                .a, .left => {
                    game.state.keys &= ~Dir.left;
                },
                .d, .right => {
                    game.state.keys &= ~Dir.right;
                },
                else => {},
            },
            .framebuffer_resize => |ev| {
                // recreates the sampler, which is a waste, but for an example it's ok
                game.state.depth.release();
                game.state.depth = Texture.depth(core.device, ev.width, ev.height);
            },
            .close => try engine.send(.exit, .{}),
            else => {},
        }
    }

    // move camera
    const speed = Vec3.splat(delta_time * 5);
    const fwd = Camera.normalize(game.state.camera.target.sub(&game.state.camera.eye));
    const right = Camera.normalize(fwd.cross(&game.state.camera.up));

    if (game.state.keys & Dir.up != 0) {
        game.state.camera.eye.v += fwd.mul(&speed).v;
    } else if (game.state.keys & Dir.down != 0) {
        game.state.camera.eye.v -= fwd.mul(&speed).v;
    }

    if (game.state.keys & Dir.right != 0) {
        game.state.camera.eye.v += right.mul(&speed).v;
    } else if (game.state.keys & Dir.left != 0) {
        game.state.camera.eye.v -= right.mul(&speed).v;
    } else {
        game.state.camera.eye.v += right.mul(&speed.mulScalar(0.5)).v;
    }

    game.state.camera.update(core.queue);

    // move light
    const light_speed = delta_time * 2.5;
    game.state.light.update(core.queue, light_speed);

    try engine.send(.beginPass, .{ .{ .r = 0.0, .g = 0.0, .b = 0.4, .a = 1.0 }, &.{
        .view = game.state.depth.view,
        .depth_load_op = .clear,
        .depth_store_op = .store,
        .depth_clear_value = 1.0,
    } });

    // brick cubes
    engine.state.pass.setPipeline(game.state.cube.pipeline);
    engine.state.pass.setBindGroup(0, game.state.camera.bind_group, &.{});
    engine.state.pass.setBindGroup(1, game.state.cube.texture.bind_group.?, &.{});
    engine.state.pass.setBindGroup(2, game.state.light.bind_group, &.{});
    engine.state.pass.setVertexBuffer(0, game.state.cube.mesh.buffer, 0, game.state.cube.mesh.size);
    engine.state.pass.setVertexBuffer(1, game.state.cube.instance.buffer, 0, game.state.cube.instance.size);
    engine.state.pass.draw(4, game.state.cube.instance.len, 0, 0);
    engine.state.pass.draw(4, game.state.cube.instance.len, 4, 0);
    engine.state.pass.draw(4, game.state.cube.instance.len, 8, 0);
    engine.state.pass.draw(4, game.state.cube.instance.len, 12, 0);
    engine.state.pass.draw(4, game.state.cube.instance.len, 16, 0);
    engine.state.pass.draw(4, game.state.cube.instance.len, 20, 0);

    // light source
    engine.state.pass.setPipeline(game.state.light.pipeline);
    engine.state.pass.setBindGroup(0, game.state.camera.bind_group, &.{});
    engine.state.pass.setBindGroup(1, game.state.light.bind_group, &.{});
    engine.state.pass.setVertexBuffer(0, game.state.cube.mesh.buffer, 0, game.state.cube.mesh.size);
    engine.state.pass.draw(4, 1, 0, 0);
    engine.state.pass.draw(4, 1, 4, 0);
    engine.state.pass.draw(4, 1, 8, 0);
    engine.state.pass.draw(4, 1, 12, 0);
    engine.state.pass.draw(4, 1, 16, 0);
    engine.state.pass.draw(4, 1, 20, 0);

    try engine.send(.endPass, .{});
    try engine.send(.present, .{});

    // update the window title every second
    if (game.state.title_timer.read() >= 1.0) {
        game.state.title_timer.reset();
        try core.printTitle("Gen Texture Light [ {d}fps ] [ Input {d}hz ]", .{
            core.frameRate(),
            core.inputRate(),
        });
    }
}

const Dir = struct {
    const up: u8 = 0b0001;
    const down: u8 = 0b0010;
    const left: u8 = 0b0100;
    const right: u8 = 0b1000;
};

const Camera = struct {
    eye: Vec3,
    target: Vec3,
    up: Vec3,
    aspect: f32,
    fovy: f32,
    near: f32,
    far: f32,
    bind_group: *gpu.BindGroup,
    buffer: Buffer,

    const Uniform = extern struct {
        pos: Vec3,
        proj: Mat4x4 align(16),
    };

    fn init(device: *gpu.Device, eye: Vec3, target: Vec3, up: Vec3, aspect: f32, fovy: f32, near: f32, far: f32) Camera {
        var camera: Camera = .{
            .eye = eye,
            .target = target,
            .up = up,
            .aspect = aspect,
            .near = near,
            .far = far,
            .fovy = fovy,
            .buffer = undefined,
            .bind_group = undefined,
        };

        const proj = camera.buildViewProjMatrix();
        const uniform = Uniform{
            .pos = camera.eye,
            .proj = proj,
        };

        const buffer = .{
            .buffer = initBuffer(device, .{ .uniform = true }, &@as([20]f32, @bitCast(uniform))),
            .size = @sizeOf(@TypeOf(uniform)),
        };

        const layout = Camera.bindGroupLayout(device);
        const bind_group = device.createBindGroup(&gpu.BindGroup.Descriptor.init(.{
            .layout = layout,
            .entries = &.{
                gpu.BindGroup.Entry.buffer(0, buffer.buffer, 0, buffer.size),
            },
        }));
        layout.release();

        camera.buffer = buffer;
        camera.bind_group = bind_group;

        return camera;
    }

    fn deinit(camera: *Camera) void {
        camera.bind_group.release();
        camera.buffer.release();
    }

    fn update(camera: *Camera, queue: *gpu.Queue) void {
        const proj = camera.buildViewProjMatrix();
        const uniform = .{
            .pos = camera.eye,
            .proj = proj,
        };

        queue.writeBuffer(camera.buffer.buffer, 0, &[_]Uniform{uniform});
    }

    fn normalize(v: Vec3) Vec3 {
        return v.mulScalar(1 / v.len());
    }

    fn lookAtRh(eye: Vec3, dir: Vec3, up: Vec3) Mat4x4 {
        const az = normalize(eye.sub(&dir));
        const ax = normalize(up.cross(&az));
        const ay = normalize(az.cross(&ax));
        return mat4x4(
            &vec4(ax.x(), ax.y(), ax.z(), -ax.dot(&eye.sub(&dir))),
            &vec4(ay.x(), ay.y(), ay.z(), -ay.dot(&eye.sub(&dir))),
            &vec4(az.x(), az.y(), az.z(), -az.dot(&eye.sub(&dir))),
            &vec4(0.0, 0.0, 0.0, 1.0),
        );
    }

    pub fn perspectiveFovRh(fovy: f32, aspect: f32, near: f32, far: f32) Mat4x4 {
        const h = 1 / @tan(0.5 * fovy);
        const w = h / aspect;
        const r = far / (near - far);
        return mat4x4(
            &vec4(w, 0.0, 0.0, 0.0),
            &vec4(0.0, h, 0.0, 0.0),
            &vec4(0.0, 0.0, r, r * near),
            &vec4(0.0, 0.0, -1, 0.0),
        );
    }

    inline fn buildViewProjMatrix(s: *const Camera) Mat4x4 {
        const view = lookAtRh(s.eye, s.target, s.up);
        const proj = perspectiveFovRh(s.fovy, s.aspect, s.near, s.far);
        return proj.mul(&view);
    }

    inline fn bindGroupLayout(device: *gpu.Device) *gpu.BindGroupLayout {
        const visibility = .{ .vertex = true, .fragment = true };
        return device.createBindGroupLayout(&gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &.{
                gpu.BindGroupLayout.Entry.buffer(0, visibility, .uniform, false, 0),
            },
        }));
    }
};

const Buffer = struct {
    buffer: *gpu.Buffer,
    size: usize,
    len: u32 = 0,

    fn release(buffer: *Buffer) void {
        buffer.buffer.release();
    }
};

const Cube = struct {
    pipeline: *gpu.RenderPipeline,
    mesh: Buffer,
    instance: Buffer,
    texture: Texture,

    const IPR = 20; // instances per row
    const SPACING = 2; // spacing between cubes
    const DISPLACEMENT = vec3u(IPR * SPACING / 2, 0, IPR * SPACING / 2);

    fn init() Cube {
        const device = core.device;

        const texture = Brick.texture(device);

        // instance buffer
        var ibuf: [IPR * IPR * 16]f32 = undefined;

        var z: usize = 0;
        while (z < IPR) : (z += 1) {
            var x: usize = 0;
            while (x < IPR) : (x += 1) {
                const pos = vec3u(x * SPACING, 0, z * SPACING) - DISPLACEMENT;
                const rot = blk: {
                    if (pos[0] == 0 and pos[2] == 0) {
                        break :blk zm.rotationZ(0.0);
                    } else {
                        break :blk zm.mul(zm.rotationX(zm.clamp(zm.abs(pos[0]), 0, 45.0)), zm.rotationZ(zm.clamp(zm.abs(pos[2]), 0, 45.0)));
                    }
                };
                const index = z * IPR + x;
                const inst = Instance{
                    .position = pos,
                    .rotation = rot,
                };
                zm.storeMat(ibuf[index * 16 ..], inst.toMat());
            }
        }

        const instance = Buffer{
            .buffer = initBuffer(device, .{ .vertex = true }, &ibuf),
            .len = IPR * IPR,
            .size = @sizeOf(@TypeOf(ibuf)),
        };

        return Cube{
            .mesh = mesh(device),
            .texture = texture,
            .instance = instance,
            .pipeline = pipeline(),
        };
    }

    fn deinit(cube: *Cube) void {
        cube.pipeline.release();
        cube.mesh.release();
        cube.instance.release();
        cube.texture.release();
    }

    fn pipeline() *gpu.RenderPipeline {
        const device = core.device;

        const camera_layout = Camera.bindGroupLayout(device);
        const texture_layout = Texture.bindGroupLayout(device);
        const light_layout = Light.bindGroupLayout(device);
        const layout_descriptor = gpu.PipelineLayout.Descriptor.init(.{
            .bind_group_layouts = &.{
                camera_layout,
                texture_layout,
                light_layout,
            },
        });
        defer camera_layout.release();
        defer texture_layout.release();
        defer light_layout.release();

        const layout = device.createPipelineLayout(&layout_descriptor);
        defer layout.release();

        const shader = device.createShaderModuleWGSL("cube.wgsl", @embedFile("cube.wgsl"));
        defer shader.release();

        const blend = gpu.BlendState{};
        const color_target = gpu.ColorTargetState{
            .format = core.descriptor.format,
            .blend = &blend,
        };

        const fragment = gpu.FragmentState.init(.{
            .module = shader,
            .entry_point = "fs_main",
            .targets = &.{color_target},
        });

        const descriptor = gpu.RenderPipeline.Descriptor{
            .layout = layout,
            .fragment = &fragment,
            .vertex = gpu.VertexState.init(.{
                .module = shader,
                .entry_point = "vs_main",
                .buffers = &.{
                    Cube.vertexBufferLayout(),
                    Cube.instanceLayout(),
                },
            }),
            .depth_stencil = &.{
                .format = Texture.DEPTH_FORMAT,
                .depth_write_enabled = .true,
                .depth_compare = .less,
            },
            .primitive = .{
                .cull_mode = .back,
                .topology = .triangle_strip,
            },
        };

        return device.createRenderPipeline(&descriptor);
    }

    fn mesh(device: *gpu.Device) Buffer {
        // generated texture has aspect ratio of 1:2
        // `h` reflects that ratio
        // `v` sets how many times texture repeats across surface
        const v = 2;
        const h = v * 2;
        const buf = asFloats(.{
            // z+ face
            0, 0, 1, 0,  0,  1,  0, h,
            1, 0, 1, 0,  0,  1,  v, h,
            0, 1, 1, 0,  0,  1,  0, 0,
            1, 1, 1, 0,  0,  1,  v, 0,
            // z- face
            1, 0, 0, 0,  0,  -1, 0, h,
            0, 0, 0, 0,  0,  -1, v, h,
            1, 1, 0, 0,  0,  -1, 0, 0,
            0, 1, 0, 0,  0,  -1, v, 0,
            // x+ face
            1, 0, 1, 1,  0,  0,  0, h,
            1, 0, 0, 1,  0,  0,  v, h,
            1, 1, 1, 1,  0,  0,  0, 0,
            1, 1, 0, 1,  0,  0,  v, 0,
            // x- face
            0, 0, 0, -1, 0,  0,  0, h,
            0, 0, 1, -1, 0,  0,  v, h,
            0, 1, 0, -1, 0,  0,  0, 0,
            0, 1, 1, -1, 0,  0,  v, 0,
            // y+ face
            1, 1, 0, 0,  1,  0,  0, h,
            0, 1, 0, 0,  1,  0,  v, h,
            1, 1, 1, 0,  1,  0,  0, 0,
            0, 1, 1, 0,  1,  0,  v, 0,
            // y- face
            0, 0, 0, 0,  -1, 0,  0, h,
            1, 0, 0, 0,  -1, 0,  v, h,
            0, 0, 1, 0,  -1, 0,  0, 0,
            1, 0, 1, 0,  -1, 0,  v, 0,
        });

        return Buffer{
            .buffer = initBuffer(device, .{ .vertex = true }, &buf),
            .size = @sizeOf(@TypeOf(buf)),
        };
    }

    fn vertexBufferLayout() gpu.VertexBufferLayout {
        const attributes = [_]gpu.VertexAttribute{
            .{
                .format = .float32x3,
                .offset = 0,
                .shader_location = 0,
            },
            .{
                .format = .float32x3,
                .offset = @sizeOf([3]f32),
                .shader_location = 1,
            },
            .{
                .format = .float32x2,
                .offset = @sizeOf([6]f32),
                .shader_location = 2,
            },
        };
        return gpu.VertexBufferLayout.init(.{
            .array_stride = @sizeOf([8]f32),
            .attributes = &attributes,
        });
    }

    fn instanceLayout() gpu.VertexBufferLayout {
        const attributes = [_]gpu.VertexAttribute{
            .{
                .format = .float32x4,
                .offset = 0,
                .shader_location = 3,
            },
            .{
                .format = .float32x4,
                .offset = @sizeOf([4]f32),
                .shader_location = 4,
            },
            .{
                .format = .float32x4,
                .offset = @sizeOf([8]f32),
                .shader_location = 5,
            },
            .{
                .format = .float32x4,
                .offset = @sizeOf([12]f32),
                .shader_location = 6,
            },
        };

        return gpu.VertexBufferLayout.init(.{
            .array_stride = @sizeOf([16]f32),
            .step_mode = .instance,
            .attributes = &attributes,
        });
    }
};

fn asFloats(comptime arr: anytype) [arr.len]f32 {
    comptime var len = arr.len;
    comptime var out: [len]f32 = undefined;
    comptime var i = 0;
    inline while (i < len) : (i += 1) {
        out[i] = @as(f32, @floatFromInt(arr[i]));
    }
    return out;
}

const Brick = struct {
    const W = 12;
    const H = 6;

    fn texture(device: *gpu.Device) Texture {
        const slice: []const u8 = &data();
        return Texture.fromData(device, W, H, u8, slice);
    }

    fn data() [W * H * 4]u8 {
        comptime var out: [W * H * 4]u8 = undefined;

        // fill all the texture with brick color
        comptime var i = 0;
        inline while (i < H) : (i += 1) {
            comptime var j = 0;
            inline while (j < W * 4) : (j += 4) {
                out[i * W * 4 + j + 0] = 210;
                out[i * W * 4 + j + 1] = 30;
                out[i * W * 4 + j + 2] = 30;
                out[i * W * 4 + j + 3] = 0;
            }
        }

        const f = 10;

        // fill the cement lines
        inline for ([_]comptime_int{ 0, 1 }) |k| {
            inline for ([_]comptime_int{ 5 * 4, 11 * 4 }) |m| {
                out[k * W * 4 + m + 0] = f;
                out[k * W * 4 + m + 1] = f;
                out[k * W * 4 + m + 2] = f;
                out[k * W * 4 + m + 3] = 0;
            }
        }

        inline for ([_]comptime_int{ 3, 4 }) |k| {
            inline for ([_]comptime_int{ 2 * 4, 8 * 4 }) |m| {
                out[k * W * 4 + m + 0] = f;
                out[k * W * 4 + m + 1] = f;
                out[k * W * 4 + m + 2] = f;
                out[k * W * 4 + m + 3] = 0;
            }
        }

        inline for ([_]comptime_int{ 2, 5 }) |k| {
            comptime var m = 0;
            inline while (m < W * 4) : (m += 4) {
                out[k * W * 4 + m + 0] = f;
                out[k * W * 4 + m + 1] = f;
                out[k * W * 4 + m + 2] = f;
                out[k * W * 4 + m + 3] = 0;
            }
        }

        return out;
    }
};

// don't confuse with gpu.Texture
const Texture = struct {
    texture: *gpu.Texture,
    view: *gpu.TextureView,
    sampler: *gpu.Sampler,
    bind_group: ?*gpu.BindGroup,

    const DEPTH_FORMAT = .depth32_float;
    const FORMAT = .rgba8_unorm;

    fn release(texture: *Texture) void {
        texture.texture.release();
        texture.view.release();
        texture.sampler.release();
        if (texture.bind_group) |bind_group| bind_group.release();
    }

    fn fromData(device: *gpu.Device, width: u32, height: u32, comptime T: type, data: []const T) Texture {
        const extent = gpu.Extent3D{
            .width = width,
            .height = height,
        };

        const texture = device.createTexture(&gpu.Texture.Descriptor{
            .size = extent,
            .format = FORMAT,
            .usage = .{ .copy_dst = true, .texture_binding = true },
        });

        const view = texture.createView(&gpu.TextureView.Descriptor{
            .format = FORMAT,
            .dimension = .dimension_2d,
            .array_layer_count = 1,
            .mip_level_count = 1,
        });

        const sampler = device.createSampler(&gpu.Sampler.Descriptor{
            .address_mode_u = .repeat,
            .address_mode_v = .repeat,
            .address_mode_w = .repeat,
            .mag_filter = .linear,
            .min_filter = .linear,
            .mipmap_filter = .linear,
            .max_anisotropy = 1, // 1,2,4,8,16
        });

        core.queue.writeTexture(
            &gpu.ImageCopyTexture{
                .texture = texture,
            },
            &gpu.Texture.DataLayout{
                .bytes_per_row = 4 * width,
                .rows_per_image = height,
            },
            &extent,
            data,
        );

        const bind_group_layout = Texture.bindGroupLayout(device);
        const bind_group = device.createBindGroup(&gpu.BindGroup.Descriptor.init(.{
            .layout = bind_group_layout,
            .entries = &.{
                gpu.BindGroup.Entry.textureView(0, view),
                gpu.BindGroup.Entry.sampler(1, sampler),
            },
        }));
        bind_group_layout.release();

        return Texture{
            .view = view,
            .texture = texture,
            .sampler = sampler,
            .bind_group = bind_group,
        };
    }

    fn depth(device: *gpu.Device, width: u32, height: u32) Texture {
        const extent = gpu.Extent3D{
            .width = width,
            .height = height,
        };

        const texture = device.createTexture(&gpu.Texture.Descriptor{
            .size = extent,
            .format = DEPTH_FORMAT,
            .usage = .{
                .render_attachment = true,
                .texture_binding = true,
            },
        });

        const view = texture.createView(&gpu.TextureView.Descriptor{
            .dimension = .dimension_2d,
            .array_layer_count = 1,
            .mip_level_count = 1,
        });

        const sampler = device.createSampler(&gpu.Sampler.Descriptor{
            .mag_filter = .linear,
            .compare = .less_equal,
        });

        return Texture{
            .texture = texture,
            .view = view,
            .sampler = sampler,
            .bind_group = null, // not used
        };
    }

    inline fn bindGroupLayout(device: *gpu.Device) *gpu.BindGroupLayout {
        const visibility = .{ .fragment = true };
        const Entry = gpu.BindGroupLayout.Entry;
        return device.createBindGroupLayout(&gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &.{
                Entry.texture(0, visibility, .float, .dimension_2d, false),
                Entry.sampler(1, visibility, .filtering),
            },
        }));
    }
};

const Light = struct {
    uniform: Uniform,
    buffer: Buffer,
    bind_group: *gpu.BindGroup,
    pipeline: *gpu.RenderPipeline,

    const Uniform = extern struct {
        position: Vec,
        color: Vec,
    };

    fn init() Light {
        const device = core.device;
        const uniform = Uniform{
            .color = vec3u(1, 1, 1),
            .position = vec3u(3, 7, 2),
        };

        const buffer = .{
            .buffer = initBuffer(device, .{ .uniform = true }, &@as([8]f32, @bitCast(uniform))),
            .size = @sizeOf(@TypeOf(uniform)),
        };

        const layout = Light.bindGroupLayout(device);
        const bind_group = device.createBindGroup(&gpu.BindGroup.Descriptor.init(.{
            .layout = layout,
            .entries = &.{
                gpu.BindGroup.Entry.buffer(0, buffer.buffer, 0, buffer.size),
            },
        }));
        layout.release();

        return Light{
            .buffer = buffer,
            .uniform = uniform,
            .bind_group = bind_group,
            .pipeline = Light.pipeline(),
        };
    }

    fn deinit(light: *Light) void {
        light.buffer.release();
        light.bind_group.release();
        light.pipeline.release();
    }

    fn update(light: *Light, queue: *gpu.Queue, delta: f32) void {
        const old = light.uniform;
        const new = Light.Uniform{
            .position = zm.qmul(zm.quatFromAxisAngle(vec3u(0, 1, 0), delta), old.position),
            .color = old.color,
        };
        queue.writeBuffer(light.buffer.buffer, 0, &[_]Light.Uniform{new});
        light.uniform = new;
    }

    inline fn bindGroupLayout(device: *gpu.Device) *gpu.BindGroupLayout {
        const visibility = .{ .vertex = true, .fragment = true };
        const Entry = gpu.BindGroupLayout.Entry;
        return device.createBindGroupLayout(&gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &.{
                Entry.buffer(0, visibility, .uniform, false, 0),
            },
        }));
    }

    fn pipeline() *gpu.RenderPipeline {
        const device = core.device;

        const camera_layout = Camera.bindGroupLayout(device);
        const light_layout = Light.bindGroupLayout(device);
        const layout_descriptor = gpu.PipelineLayout.Descriptor.init(.{
            .bind_group_layouts = &.{
                camera_layout,
                light_layout,
            },
        });
        defer camera_layout.release();
        defer light_layout.release();

        const layout = device.createPipelineLayout(&layout_descriptor);
        defer layout.release();

        const shader = core.device.createShaderModuleWGSL("light.wgsl", @embedFile("light.wgsl"));
        defer shader.release();

        const blend = gpu.BlendState{};
        const color_target = gpu.ColorTargetState{
            .format = core.descriptor.format,
            .blend = &blend,
        };

        const fragment = gpu.FragmentState.init(.{
            .module = shader,
            .entry_point = "fs_main",
            .targets = &.{color_target},
        });

        const descriptor = gpu.RenderPipeline.Descriptor{
            .layout = layout,
            .fragment = &fragment,
            .vertex = gpu.VertexState.init(.{
                .module = shader,
                .entry_point = "vs_main",
                .buffers = &.{
                    Cube.vertexBufferLayout(),
                },
            }),
            .depth_stencil = &.{
                .format = Texture.DEPTH_FORMAT,
                .depth_write_enabled = .true,
                .depth_compare = .less,
            },
            .primitive = .{
                .cull_mode = .back,
                .topology = .triangle_strip,
            },
        };

        return device.createRenderPipeline(&descriptor);
    }
};

inline fn initBuffer(device: *gpu.Device, usage: gpu.Buffer.UsageFlags, data: anytype) *gpu.Buffer {
    std.debug.assert(@typeInfo(@TypeOf(data)) == .Pointer);
    const T = std.meta.Elem(@TypeOf(data));

    var u = usage;
    u.copy_dst = true;
    const buffer = device.createBuffer(&.{
        .size = @sizeOf(T) * data.len,
        .usage = u,
        .mapped_at_creation = .true,
    });

    var mapped = buffer.getMappedRange(T, 0, data.len);
    std.mem.copy(T, mapped.?, data);
    buffer.unmap();
    return buffer;
}

fn vec3i(x: isize, y: isize, z: isize) Vec {
    return Vec{ @floatFromInt(x), @floatFromInt(y), @floatFromInt(z), 0.0 };
}

fn vec3u(x: usize, y: usize, z: usize) Vec {
    return zm.Vec{ @floatFromInt(x), @floatFromInt(y), @floatFromInt(z), 0.0 };
}

// todo indside Cube
const Instance = struct {
    position: Vec,
    rotation: Mat,

    fn toMat(instance: Instance) Mat {
        return zm.mul(instance.rotation, zm.translationV(instance.position));
    }
};
