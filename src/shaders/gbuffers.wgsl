struct Camera {
  position: vec3<f32>,
  view: mat4x4<f32>,
  projection_view: mat4x4<f32>,
  inverse_projection_view: mat4x4<f32>,
}

@group(0) @binding(0) var<uniform> camera: Camera;
@group(0) @binding(1) var texture: texture_2d<f32>;
@group(0) @binding(2) var normal_texture: texture_2d<f32>;
@group(0) @binding(3) var diffuse_sampler: sampler;

struct VertexOutput {
  @builtin(position) position: vec4<f32>,
  @location(0) normal: vec4<f32>,
  @location(1) uv: vec2<f32>,
  @location(2) world_pos: vec4<f32>,
}

@vertex
fn vertex_main(
  @location(0) position: vec3<f32>,
  @location(1) normal: vec3<f32>,
  @location(2) tanget: vec4<f32>,
  @location(3) uv: vec2<f32>,
  @location(4) model_0: vec4<f32>,
  @location(5) model_1: vec4<f32>,
  @location(6) model_2: vec4<f32>,
  @location(7) model_3: vec4<f32>,
  @location(8) normal_model_0: vec4<f32>,
  @location(9) normal_model_1: vec4<f32>,
  @location(10) normal_model_2: vec4<f32>,
  @location(11) normal_model_3: vec4<f32>,
) -> VertexOutput {
  let model = mat4x4(model_0, model_1, model_2, model_3);
  let normal_model = mat4x4(normal_model_0, normal_model_1, normal_model_2, normal_model_3);

  var output : VertexOutput;
  output.position = camera.projection_view * model * vec4(position, 1.0);
  output.world_pos = model * vec4(position, 1.0);
  output.normal = normalize(normal_model * vec4(normal, 0));
  output.uv = uv;
  return output;
}

struct GBufferOutput {
  @location(0) position: vec4<f32>,
  @location(1) normal: vec4<f32>,
  @location(2) albedo: vec4<f32>,
}

@fragment
fn frag_main(in: VertexOutput) -> GBufferOutput {
  var output: GBufferOutput;
  output.position = in.world_pos;
  output.normal = in.normal;
  output.albedo = textureSample(texture, diffuse_sampler, in.uv);
  return output;
}