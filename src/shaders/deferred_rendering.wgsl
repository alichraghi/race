struct LightData {
  position: vec3<f32>,
  color: vec4<f32>,
  radius: f32,
}

struct LightBuffer {
    len: u32,
    lights: array<LightData, 10>,
};

struct Camera {
  view_projection: mat4x4<f32>,
  inverse_view_projection: mat4x4<f32>,
}

@group(0) @binding(0) var gbuffer_normal: texture_2d<f32>;
@group(0) @binding(1) var gbuffe_albedo: texture_2d<f32>;
@group(0) @binding(2) var gbuffer_depth: texture_depth_2d;

@group(1) @binding(0) var<uniform> camera: Camera;
@group(1) @binding(1) var<uniform> lights: LightBuffer;

fn worldFromScreenCoord(coord: vec2<f32>, depth_sample: f32) -> vec3<f32> {
  // reconstruct world-space position from the screen coordinate.
  let pos_clip = vec4(coord.x * 2.0 - 1.0, (1.0 - coord.y) * 2.0 - 1.0, depth_sample, 1.0);
  let pos_world_w = camera.inverse_view_projection * pos_clip;
  let pos_world = pos_world_w.xyz / pos_world_w.www;
  return pos_world;
}

@fragment
fn frag_main(@builtin(position) coord: vec4<f32>) -> @location(0) vec4<f32> {
  let depth = textureLoad(gbuffer_depth, vec2<i32>(floor(coord.xy)), 0);

  // Don't light the sky.
  if (depth >= 1.0) {
    discard;
  }

  let buffer_size = textureDimensions(gbuffer_depth);
  let coord_uv = coord.xy / vec2<f32>(buffer_size);
  let position = worldFromScreenCoord(coord_uv, depth);

  let normal = textureLoad(gbuffer_normal, vec2<i32>(floor(coord.xy)), 0).xyz;
  let albedo = textureLoad(gbuffe_albedo, vec2<i32>(floor(coord.xy)), 0).rgb;

  var result: vec3<f32>;
  for (var i = 0u; i < lights.len; i++) {
    let L = lights.lights[i].position - position;
    let distance = length(L);

    let lambert = max(dot(normal, normalize(L)), 0.0);
    result += lambert * pow(1.0 - distance / lights.lights[i].radius, 2.0) * lights.lights[i].color.xyz * lights.lights[i].color.w * albedo;
  }

  // some manual ambient
  result += vec3(0.2);

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
