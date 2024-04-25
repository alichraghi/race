struct LightData {
  position: vec3<f32>,
  color: vec4<f32>,
  radius: f32,
}

struct LightBuffer {
    len: u32,
    lights: array<LightData, 128>,
};

struct Camera {
  view: mat4x4<f32>,
  projection_view: mat4x4<f32>,
  inverse_projection_view: mat4x4<f32>,
}

@group(0) @binding(0) var<uniform> camera: Camera;
@group(0) @binding(1) var<uniform> lights: LightBuffer;
@group(0) @binding(2) var gbuffer_depth: texture_depth_2d;

struct Output {
    @builtin(position) position: vec4<f32>,
    @location(0) offset: vec2<f32>,
    @location(1) @interpolate(flat) index: u32,
};

@vertex
fn vertex_main(
    @builtin(vertex_index) vertex_index: u32, 
    @builtin(instance_index) index: u32
) -> Output {
    const offsets = array(
        vec2(-1.0, -1.0),
        vec2(-1.0, 1.0),
        vec2(1.0, -1.0),
        vec2(1.0, -1.0),
        vec2(-1.0, 1.0),
        vec2(1.0, 1.0)
    );

    let offset = offsets[vertex_index];
    let camera_right_world = vec3(camera.view[0][0], camera.view[1][0], camera.view[2][0]);
    let camera_up_world = vec3(camera.view[0][1], camera.view[1][1], camera.view[2][1]);

    let position_world = lights.lights[index].position
                       + offset.x * camera_right_world * 0.1
                       + offset.y * camera_up_world * 0.1;

    var output: Output;
    output.position = camera.projection_view * vec4(position_world, 1.0);
    output.offset = offset;
    output.index = index;
    return output;
}

const pi = 3.1415926538;

@fragment
fn frag_main(in: Output) -> @location(0) vec4<f32> {
    let depth = textureLoad(gbuffer_depth, vec2<i32>(floor(in.position.xy)), 0);

    // TODO: why this doesn't work?
    // if (depth >= 1) {
    //   discard;
    // }

    let dis = sqrt(dot(in.offset, in.offset));
    if (dis >= 1.0) {
      discard;
    }

    let cos_dis = 0.4 * (cos(dis * pi) + 1.0);
    return vec4(lights.lights[in.index].color.xyz + cos_dis, cos_dis);
}