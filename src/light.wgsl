const light_radius = 0.05;
const offsets = array(
  vec2(-1.0, -1.0),
  vec2(-1.0, 1.0),
  vec2(1.0, -1.0),
  vec2(1.0, -1.0),
  vec2(-1.0, 1.0),
  vec2(1.0, 1.0)
);

struct UBO {
    projection: mat4x4<f32>,
    view: mat4x4<f32>,
    light_position: vec3<f32>,
    light_color: vec4<f32>,
};

@group(0) @binding(0) var<uniform> ubo: UBO;

struct Output {
    @builtin(position) position: vec4<f32>,
    @location(0) offset: vec2<f32>,
};

@vertex
fn vertex_main(@builtin(vertex_index) vertex_index: u32) -> Output {
  let offset = offsets[vertex_index];
  let camera_right_world = vec3(ubo.view[0][0], ubo.view[1][0], ubo.view[2][0]);
  let camera_up_world = vec3(ubo.view[0][1], ubo.view[1][1], ubo.view[2][1]);

  let position_world = ubo.light_position
    + light_radius * offset.x * camera_right_world
    + light_radius * offset.y * camera_up_world;

  var output: Output;
  output.position = ubo.projection * ubo.view * vec4(position_world, 1.0);
  output.offset = offset;

  return output;
}

@fragment
fn frag_main(in: Output) -> @location(0) vec4<f32> {
  let dis = sqrt(dot(in.offset, in.offset));
  if (dis >= 1.0) {
    discard;
  }
  return ubo.light_color;
}