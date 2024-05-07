struct Camera {
    projection: mat4x4<f32>,
    view: mat4x4<f32>,
};

struct Light {
    position: vec3<f32>,
    color: vec4<f32>,
    radius: f32,
};

const PI = radians(180);

@group(0) @binding(0) var<uniform> camera: Camera;
@group(0) @binding(1) var<uniform> light: Light;

struct Output {
    @builtin(position) position: vec4<f32>,
    @location(0) offset: vec2<f32>,
};

@vertex
fn vertex_main(@builtin(vertex_index) vertex_index: u32) -> Output {
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

    let position_world = light.position
                       + light.radius * offset.x * camera_right_world
                       + light.radius * offset.y * camera_up_world;

    var output: Output;
    output.position = camera.projection * camera.view * vec4(position_world, 1.0);
    output.offset = offset;
    return output;
}

@fragment
fn frag_main(in: Output) -> @location(0) vec4<f32> {
    let distance = sqrt(dot(in.offset, in.offset));
    if (distance >= 1.0) {
      discard;
    }
    let cos_distance = 0.5 * (cos(distance * PI) + 1.0);
    return vec4(light.color.xyz + cos_distance, cos_distance);
}