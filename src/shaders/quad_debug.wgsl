const MODE_ALBEDO = 1;
const MODE_NORMAL = 2;
const MODE_DEPTH = 3;

struct Camera {
  view: mat4x4<f32>,
  projection_view: mat4x4<f32>,
  inverse_projection_view: mat4x4<f32>,
}

@group(0) @binding(0) var gbuffer_normal: texture_2d<f32>;
@group(0) @binding(1) var gbuffe_albedo: texture_2d<f32>;
@group(0) @binding(2) var gbuffer_depth: texture_depth_2d;

@group(1) @binding(0) var<uniform> mode: u32;

@fragment
fn frag_main(@builtin(position) coord: vec4<f32>) -> @location(0) vec4<f32> {
  switch mode {
    case MODE_DEPTH: {
      let depth = textureLoad(gbuffer_depth, vec2<i32>(floor(coord.xy)), 0);
      // remap depth into something a bit more visible
      return vec4((1.0 - depth) * 50.0);
    }
    case MODE_ALBEDO: {
      return textureLoad(gbuffe_albedo, vec2<i32>(floor(coord.xy)), 0);
    }
    case MODE_NORMAL: {
      var result = textureLoad(gbuffer_normal, vec2<i32>(floor(coord.xy)), 0);
      result.x = (result.x + 1.0) * 0.5;
      result.y = (result.y + 1.0) * 0.5;
      result.z = (result.z + 1.0) * 0.5;
      return result;
    }
    default {
      discard;
    }
  }

  // TODO: Tint is too stupid rn so we have to keep this return for now
  return vec4(0);
}


@vertex
fn vertex_main(@builtin(vertex_index) vertex_index: u32) -> @builtin(position) vec4<f32> {
  const pos = array(
    vec2(-1.0, -1.0), vec2(1.0, -1.0), vec2(-1.0, 1.0),
    vec2(-1.0, 1.0), vec2(1.0, -1.0), vec2(1.0, 1.0),
  );
  return vec4<f32>(pos[vertex_index], 0.0, 1.0);
}
