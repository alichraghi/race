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
  position: vec3<f32>,
  view: mat4x4<f32>,
  projection_view: mat4x4<f32>,
  inverse_projection_view: mat4x4<f32>,
}

@group(0) @binding(0) var gbuffer_normal: texture_2d<f32>;
@group(0) @binding(1) var gbuffe_albedo: texture_2d<f32>;
@group(0) @binding(2) var gbuffer_depth: texture_depth_2d;
@group(0) @binding(3) var gbuffer_sampler: sampler;
@group(0) @binding(4) var gbuffer_position: texture_2d<f32>;

@group(1) @binding(0) var<uniform> camera: Camera;
@group(1) @binding(1) var<uniform> lights: LightBuffer;

@vertex
fn vertex_main(@builtin(vertex_index) vertex_index: u32) -> @builtin(position) vec4<f32> {
  const pos = array(
    vec2(-1.0, -1.0), vec2(1.0, -1.0), vec2(-1.0, 1.0),
    vec2(-1.0, 1.0), vec2(1.0, -1.0), vec2(1.0, 1.0),
  );
  return vec4<f32>(pos[vertex_index], 0.0, 1.0);
}

@fragment
fn frag_main(@builtin(position) coord: vec4<f32>) -> @location(0) vec4<f32> {
    let depth = textureLoad(gbuffer_depth, vec2<i32>(floor(coord.xy)), 0);
    if (depth >= 1.0) {
      discard; // Don't light the sky.
    }

    let position_world = textureLoad(gbuffer_position, vec2<i32>(floor(coord.xy)), 0).xyz;
    let albedo         = textureLoad(gbuffe_albedo, vec2<i32>(floor(coord.xy)), 0).rgb;
    let normal         = textureLoad(gbuffer_normal, vec2<i32>(floor(coord.xy)), 0).rgb;
    let ambient        = vec4<f32>(1, 1, 1, 0.1);


    var diffuse_light = ambient.xyz * ambient.w;
    var specular_light = vec3(0.0);

    let camera_position_wolrd = transpose(camera.view)[3].xyz;
    let view_direction = normalize(camera_position_wolrd - position_world);

    for(var i: u32 = 0; i < lights.len; i++) {
        let light = lights.lights[i];

        let light_dir = normalize(light.position - position_world);
        let distance = length(light.position - position_world);
        let attenuation = 1.0 / (distance * distance); // distance squared

        let cos_ang_incidence = max(dot(normal, light_dir), 0);
        let intensity = light.color.xyz * light.color.w * attenuation;

        diffuse_light += intensity * cos_ang_incidence;

        // Specular lighting
        let half_angle = normalize(light_dir + view_direction);
        var blinn_term = dot(normal, half_angle);
        blinn_term = clamp(blinn_term, 0, 1);
        blinn_term = pow(blinn_term, 32); // higher -> shareper highlight
        specular_light += intensity * blinn_term;
    }   

    var color = diffuse_light * albedo + specular_light * albedo;

    // HDR tonemapping
    color = color / (color + vec3(1.0));
    // Gamma correction
    color = pow(color, vec3(1.0/2.2)); 

    return vec4(color, 1);
}