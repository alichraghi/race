const std = @import("std");
const build_options = @import("build_options");
const mach = @import("mach");
const Model = @import("Model.zig");
const Camera = @import("Camera.zig");
const Texture = @import("Texture.zig");
const shaders = @import("shaders.zig");
const math = @import("math.zig");
const gpu = mach.gpu;
const Vec3 = math.Vec3;
const Mat3x3 = math.Mat3x3;
const Mat4x4 = math.Mat4x4;
const vec3 = math.vec3;
const vec4 = math.vec4;
const mat3x3 = math.mat3x3;

const Renderer = @This();

pub const name = .renderer;
pub const Mod = mach.Mod(Renderer);

pub const components = .{
    .model = .{ .type = Model },
    .transform = .{ .type = Transform },
    .instances = .{ .type = []Transform },
};

pub const events = .{
    .deinit = .{ .handler = deinit },
    .framebufferResize = .{ .handler = framebufferResize },
    .render = .{ .handler = render },
    .beginRender = .{ .handler = beginRender },
    .endRender = .{ .handler = endRender },
};

limits: gpu.SupportedLimits,

pass: *gpu.RenderPassEncoder,
encoder: *gpu.CommandEncoder,
depth_texture: *gpu.Texture,
depth_view: *gpu.TextureView,

pipelines: std.ArrayHashMapUnmanaged(Pipeline.Config, Pipeline, Pipeline.Config.ArrayHashContext, false) = .{},
shader: *gpu.ShaderModule,
camera_uniform: *gpu.Buffer,
lights_uniform: *gpu.Buffer,
instance_buffer: *gpu.Buffer,
sampler: *gpu.Sampler,
material_params_uniform: *gpu.Buffer,
material_params_uniform_stride: u32,
default_material: Model.Material,

pub const Transform = struct {
    translation: Vec3 = vec3(0, 0, 0),
    rotation: Vec3 = vec3(0, 0, 0),
    scale: Vec3 = vec3(1, 1, 1),
};

const Pipeline = struct {
    pipeline: *gpu.RenderPipeline,
    bind_group: *gpu.BindGroup,

    pub const Config = struct {
        material: Model.Material,

        pub const ArrayHashContext = struct {
            pub fn eql(ctx: ArrayHashContext, a: Config, b: Config, _: usize) bool {
                _ = ctx;

                var eql_normal = false;
                if (a.material.normal != null and b.material.normal != null) {
                    eql_normal = a.material.normal.?.view == b.material.normal.?.view;
                } else if (a.material.normal == null and b.material.normal == null) {
                    eql_normal = true;
                }

                // NOTE: We don't compare float values but this should be enough
                return a.material.texture.view == b.material.texture.view and
                    std.mem.eql(u8, a.material.name, b.material.name) and eql_normal;
            }

            pub fn hash(ctx: ArrayHashContext, a: Config) u32 {
                _ = ctx;
                var xx32 = std.hash.XxHash32.init(0);
                xx32.update(a.material.name);
                xx32.update(&std.mem.toBytes(@intFromPtr(a.material.texture.view)));
                if (a.material.normal) |normal| {
                    xx32.update(&std.mem.toBytes(@intFromPtr(normal.view)));
                }
                return xx32.final();
            }
        };
    };

    fn deinit(pipeline: Pipeline) void {
        pipeline.pipeline.release();
        pipeline.bind_group.release();
    }
};

const max_scene_objects = 1024;
const max_materials = 1024;

pub fn init(state: *Renderer) !void {
    state.limits = gpu.SupportedLimits{ .limits = .{ .min_uniform_buffer_offset_alignment = 256 } };
    if (!build_options.use_sysgpu) {
        _ = mach.core.device.getLimits(&state.limits);
    }

    const min_uniform_alignment = state.limits.limits.min_uniform_buffer_offset_alignment;
    state.material_params_uniform_stride = math.uniformStride(shaders.MaterialParams, min_uniform_alignment);

    state.createTextures(.{ .width = mach.core.descriptor.width, .height = mach.core.descriptor.height });
    state.shader = mach.core.device.createShaderModuleWGSL("object", @embedFile("shaders/object.wgsl"));
    state.camera_uniform = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(shaders.CameraUniform),
        .mapped_at_creation = .false,
    });
    state.lights_uniform = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(shaders.LightListUniform),
        .mapped_at_creation = .false,
    });
    state.instance_buffer = mach.core.device.createBuffer(&.{
        .usage = .{ .vertex = true, .copy_dst = true },
        .size = @sizeOf(shaders.InstanceData) * max_scene_objects, // TODO: enough?
        .mapped_at_creation = .false,
    });
    state.material_params_uniform = mach.core.device.createBuffer(&.{
        .usage = .{ .uniform = true, .copy_dst = true },
        .size = @sizeOf(shaders.MaterialParams) * max_materials,
        .mapped_at_creation = .false,
    });
    state.sampler = mach.core.device.createSampler(&.{ .mag_filter = .linear, .min_filter = .linear });
    state.default_material = .{
        .name = "Default Material",
        .texture = try Texture.initFromFile("assets/prototype-textures/Dark/texture_02.png"),
        .normal = try Texture.init(1, 1, .rgba, &.{ 128, 128, 255, 255 }),
    };
    state.encoder = mach.core.device.createCommandEncoder(&.{});
}

fn deinit(renderer: *Mod) !void {
    const state: *Renderer = renderer.state();

    state.shader.release();
    state.camera_uniform.release();
    state.lights_uniform.release();
    for (state.pipelines.values()) |pipeline| {
        pipeline.pipeline.release();
        pipeline.bind_group.release();
    }
    state.pipelines.deinit(mach.core.allocator);
    state.default_material.deinit();
}

pub fn framebufferResize(state: *Renderer, size: mach.core.Size) void {
    state.depth_view.release();
    state.depth_texture.release();
    state.createTextures(size);

    for (state.pipelines.keys(), state.pipelines.values()) |config, *pipeline| {
        pipeline.deinit();
        pipeline.* = state.createPipeline(config);
    }
}

fn beginRender(renderer: *Mod) !void {
    const state: *Renderer = renderer.state();

    const back_buffer_view = mach.core.swap_chain.getCurrentTextureView().?;
    defer back_buffer_view.release();

    const color_attachment = gpu.RenderPassColorAttachment{
        .view = back_buffer_view,
        .clear_value = .{ .r = 0, .g = 0, .b = 0, .a = 0 },
        .load_op = .clear,
        .store_op = .store,
    };
    const pass_info = gpu.RenderPassDescriptor.init(.{
        .color_attachments = &.{color_attachment},
        .depth_stencil_attachment = &.{
            .view = state.depth_view,
            .depth_clear_value = 1.0,
            .depth_load_op = .clear,
            .depth_store_op = .store,
        },
    });

    state.pass = state.encoder.beginRenderPass(&pass_info);
}

fn endRender(renderer: *Mod, core: *mach.Core.Mod) !void {
    const state: *Renderer = renderer.state();

    state.pass.end();
    state.pass.release();

    var command = state.encoder.finish(null);
    defer command.release();
    state.encoder.release();
    mach.core.queue.submit(&[_]*gpu.CommandBuffer{command});

    // Prepare for next pass
    state.encoder = mach.core.device.createCommandEncoder(&.{});
    core.send(.present_frame, .{});
}

fn createTextures(state: *Renderer, screen_size: mach.core.Size) void {
    state.depth_texture = mach.core.device.createTexture(&gpu.Texture.Descriptor{
        .size = gpu.Extent3D{ .width = screen_size.width, .height = screen_size.height },
        .format = .depth24_plus,
        .usage = .{
            .render_attachment = true,
            .texture_binding = true,
        },
    });
    state.depth_view = state.depth_texture.createView(&gpu.TextureView.Descriptor{
        .format = .depth24_plus,
        .dimension = .dimension_2d,
    });
}

fn createPipeline(state: *Renderer, config: Pipeline.Config) Pipeline {
    const bind_group_layout = mach.core.device.createBindGroupLayout(
        &gpu.BindGroupLayout.Descriptor.init(.{
            .entries = &.{
                gpu.BindGroupLayout.Entry.buffer(0, .{ .vertex = true, .fragment = true }, .uniform, false, 0),
                gpu.BindGroupLayout.Entry.buffer(1, .{ .vertex = true, .fragment = true }, .uniform, false, 0),
                gpu.BindGroupLayout.Entry.buffer(2, .{ .fragment = true }, .uniform, true, 0),
                gpu.BindGroupLayout.Entry.sampler(3, .{ .fragment = true }, .filtering),
                gpu.BindGroupLayout.Entry.texture(4, .{ .fragment = true }, .float, .dimension_2d, false),
                gpu.BindGroupLayout.Entry.texture(5, .{ .fragment = true }, .float, .dimension_2d, false),
            },
        }),
    );
    defer bind_group_layout.release();

    const bind_group = mach.core.device.createBindGroup(
        &gpu.BindGroup.Descriptor.init(.{
            .layout = bind_group_layout,
            .entries = &.{
                gpu.BindGroup.Entry.buffer(0, state.camera_uniform, 0, @sizeOf(shaders.CameraUniform)),
                gpu.BindGroup.Entry.buffer(1, state.lights_uniform, 0, @sizeOf(shaders.LightListUniform)),
                gpu.BindGroup.Entry.buffer(2, state.material_params_uniform, 0, @sizeOf(shaders.MaterialParams)),
                gpu.BindGroup.Entry.sampler(3, state.sampler),
                gpu.BindGroup.Entry.textureView(4, config.material.texture.view),
                gpu.BindGroup.Entry.textureView(5, (config.material.normal orelse state.default_material.normal.?).view),
            },
        }),
    );

    const pipeline_layout = mach.core.device.createPipelineLayout(
        &gpu.PipelineLayout.Descriptor.init(.{ .bind_group_layouts = &.{bind_group_layout} }),
    );
    const pipeline_descriptor = gpu.RenderPipeline.Descriptor{
        .layout = pipeline_layout,
        .fragment = &gpu.FragmentState.init(.{
            .module = state.shader,
            .entry_point = "frag_main",
            .targets = &.{.{
                .format = mach.core.descriptor.format,
                .blend = &.{},
                .write_mask = gpu.ColorWriteMaskFlags.all,
            }},
        }),
        .vertex = gpu.VertexState.init(.{
            .module = state.shader,
            .entry_point = "vertex_main",
            .buffers = &.{ shaders.Vertex.layout, shaders.InstanceData.layout },
        }),
        .depth_stencil = &.{
            .format = .depth24_plus,
            .depth_write_enabled = .true,
            .depth_compare = .less,
        },
    };
    const pipeline = mach.core.device.createRenderPipeline(&pipeline_descriptor);

    return .{
        .pipeline = pipeline,
        .bind_group = bind_group,
    };
}

fn getPipeline(state: *Renderer, config: Pipeline.Config) !*Pipeline {
    const gop = try state.pipelines.getOrPut(mach.core.allocator, config);
    if (gop.found_existing) return gop.value_ptr;
    gop.value_ptr.* = state.createPipeline(config);
    return gop.value_ptr;
}

fn render(renderer: *Mod, camera: Camera) !void {
    const state: *Renderer = renderer.state();
    const game_state: *Renderer = renderer.state();

    // Camera Uniform
    mach.core.queue.writeBuffer(
        state.camera_uniform,
        0,
        &[_]shaders.CameraUniform{.{
            .projection = camera.projection,
            .view = camera.view,
        }},
    );

    // Light Uniform
    var lights = std.BoundedArray(shaders.LightUniform, shaders.max_lights){};
    var lights_iter = renderer.entities.query(.{ .all = &.{.{ .light = &.{ .position, .color, .radius } }} });
    while (lights_iter.next()) |archetype| for (
        archetype.slice(.light, .position),
        archetype.slice(.light, .color),
        archetype.slice(.light, .radius),
    ) |position, color, radius| {
        try lights.append(.{
            .position = position, // TODO: x is reverse?!
            .color = color,
            .radius = radius,
        });
    };

    mach.core.queue.writeBuffer(
        state.lights_uniform,
        0,
        &[_]shaders.LightListUniform{.{
            .ambient = vec4(0.2, 0.2, 0.2, 0.2),
            .lights = lights.buffer,
            .len = lights.len,
        }},
    );

    // Instance Data
    var instance_offset: u32 = 0;
    var material_params_offset: u32 = 0;
    var iter = renderer.entities.query(.{ .all = &.{.{ .renderer = &.{.model} }} });
    while (iter.next()) |archetype| for (
        archetype.slice(.entity, .id),
        archetype.slice(.renderer, .model),
    ) |id, model| {
        const transform = renderer.get(id, .transform);
        const instances = renderer.get(id, .instances);

        const transforms = if (transform) |single| &.{single} else instances.?;
        std.debug.assert(transforms.len > 0);

        const instance_start_offset = instance_offset;
        for (transforms) |instance| {
            // writeBuffer is just a @memcpy
            mach.core.queue.writeBuffer(
                state.instance_buffer,
                instance_offset,
                &[_]shaders.InstanceData{.{
                    .transform = math.transform(instance.translation, instance.rotation, instance.scale),
                    .normal = math.transformNormal(instance.rotation, instance.scale),
                }},
            );
            instance_offset += @sizeOf(shaders.InstanceData);
        }

        for (model.meshes) |mesh| {
            const material = if (mesh.material) |material| model.materials[material] else state.default_material;
            const pipeline = try state.getPipeline(.{ .material = material });

            mach.core.queue.writeBuffer(
                state.material_params_uniform,
                material_params_offset,
                &[_]shaders.MaterialParams{.{
                    .metallic = material.metallic,
                    .roughness = material.roughness,
                }},
            );

            game_state.pass.setPipeline(pipeline.pipeline);
            game_state.pass.setBindGroup(0, pipeline.bind_group, &.{material_params_offset});
            game_state.pass.setVertexBuffer(0, mesh.vertex_buf, 0, mesh.vertex_count * @sizeOf(shaders.Vertex));
            game_state.pass.setVertexBuffer(1, state.instance_buffer, instance_start_offset, transforms.len * @sizeOf(shaders.InstanceData));
            if (mesh.index_buf) |index_buf| {
                game_state.pass.setIndexBuffer(index_buf, .uint32, 0, mesh.index_count * @sizeOf(u32));
                game_state.pass.drawIndexed(mesh.index_count, @intCast(transforms.len), 0, 0, 0);
            } else {
                game_state.pass.draw(mesh.vertex_count, @intCast(transforms.len), 0, 0);
            }

            material_params_offset += state.material_params_uniform_stride;
        }
    };
}
