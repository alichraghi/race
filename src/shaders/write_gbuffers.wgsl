struct Camera {
  projection_view: mat4x4<f32>,
  inverse_projection_view: mat4x4<f32>,
}

@group(0) @binding(0) var<uniform> camera: Camera;

struct VertexOutput {
  @builtin(position) position: vec4<f32>,
  @location(0) normal: vec3<f32>,
  @location(1) uv: vec2<f32>,
}

@vertex
fn vertex_main(
  @location(0) position: vec3<f32>,
  @location(1) normal: vec3<f32>,
  @location(2) uv: vec2<f32>,
  @location(3) model_0: vec4<f32>,
  @location(4) model_1: vec4<f32>,
  @location(5) model_2: vec4<f32>,
  @location(6) model_3: vec4<f32>,
  @location(7) normal_model_0: vec4<f32>,
  @location(8) normal_model_1: vec4<f32>,
  @location(9) normal_model_2: vec4<f32>,
  @location(10) normal_model_3: vec4<f32>,
) -> VertexOutput {
  let model = mat4x4(model_0, model_1, model_2, model_3);
  let normal_model = mat4x4(normal_model_0, normal_model_1, normal_model_2, normal_model_3);
  let world_position = (model * vec4(position, 1.0)).xyz;

  var output : VertexOutput;
  output.position = camera.projection_view * vec4(world_position, 1.0);
  output.normal = normalize((normal_model * vec4(normal, 1.0)).xyz);
  output.uv = uv;
  return output;
}

struct GBufferOutput {
  @location(0) normal: vec4<f32>,
  // Textures: diffuse color, specular color, smoothness, emissive etc. could go here
  @location(1) albedo: vec4<f32>,
}

@fragment
fn frag_main(in: VertexOutput) -> GBufferOutput {
  // faking some kind of checkerboard texture
  // let uv = floor(30.0 * in.uv);
  // let c = 0.2 + 0.5 * ((uv.x + uv.y) - 2.0 * floor((uv.x + uv.y) / 2.0));

  var output : GBufferOutput;
  output.normal = vec4(normalize(in.normal), 1.0);
  output.albedo = vec4(in.uv, 1.0, 1.0);

  return output;
}