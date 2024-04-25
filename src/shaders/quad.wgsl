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

@group(0) @binding(0) var gbuffer_normal: texture_2d<f32>;
@group(0) @binding(1) var gbuffe_albedo: texture_2d<f32>;
@group(0) @binding(2) var gbuffer_depth: texture_depth_2d;

@group(1) @binding(0) var<uniform> camera: Camera;
@group(1) @binding(1) var<uniform> lights: LightBuffer;

fn worldFromScreenCoord(coord: vec2<f32>, depth_sample: f32) -> vec3<f32> {
  // reconstruct world-space position from the screen coordinate.
  let pos_clip = vec4(coord.x * 2.0 - 1.0, (1.0 - coord.y) * 2.0 - 1.0, depth_sample, 1.0);
  let pos_world_w = camera.inverse_projection_view * pos_clip;
  let pos_world = pos_world_w.xyz / pos_world_w.www;
  return pos_world;
}

@fragment
fn frag_main(@builtin(position) coord: vec4<f32>) -> @location(0) vec4<f32> {
  let depth = textureLoad(gbuffer_depth, vec2<i32>(floor(coord.xy)), 0);
  if (depth >= 1.0) {
    discard; // Don't light the sky.
  }

  let albedo = textureLoad(gbuffe_albedo, vec2<i32>(floor(coord.xy)), 0).rgb;
  let normal = textureLoad(gbuffer_normal, vec2<i32>(floor(coord.xy)), 0).rgb;

  let buffer_size = textureDimensions(gbuffer_depth);
  let coord_uv = coord.xy / vec2<f32>(buffer_size);
  let position = worldFromScreenCoord(coord_uv, depth);
  let view_dir = normalize(position - coord.xyz);

  var result: vec3<f32>;
  for (var i = 0u; i < lights.len; i++) {
    let light = lights.lights[i];
    let light_dir = position - light.position;
    let distance = length(light_dir);
    if (distance < light.radius) {
      let diffuse = max(dot(normal, normalize(light_dir)), 0);
      let attenuation = light.radius / (distance * distance);
      result += diffuse * albedo * light.color.xyz * light.color.w * attenuation;
    }
  }

  // some manual ambient
  result += vec3(0.05);

  return vec4(result, 1.0);
}

@vertex
fn vertex_main(@builtin(vertex_index) vertex_index: u32) -> @builtin(position) vec4<f32> {
  const pos = array(
    vec2(-1.0, -1.0), vec2(1.0, -1.0), vec2(-1.0, 1.0),
    vec2(-1.0, 1.0), vec2(1.0, -1.0), vec2(1.0, 1.0),
  );
  return vec4<f32>(pos[vertex_index], 0.0, 1.0);
}
