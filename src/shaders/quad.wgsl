// @fragment
// fn frag_main(@builtin(position) coord: vec4<f32>) -> @location(0) vec4<f32> {
//   let depth = textureLoad(gbuffer_depth, vec2<i32>(floor(coord.xy)), 0);
//   if (depth >= 1.0) {
//     discard; // Don't light the sky.
//   }

//   let position  = textureLoad(gbuffer_position, vec2<i32>(floor(coord.xy)), 0).xyz;
//   let albedo = textureLoad(gbuffe_albedo, vec2<i32>(floor(coord.xy)), 0).rgb;
//   let normal = textureLoad(gbuffer_normal, vec2<i32>(floor(coord.xy)), 0).rgb;
//   let metallic  = textureLoad(gbuffer_metallic, vec2<i32>(floor(coord.xy)), 0).r;
//   let roughness = textureLoad(gbuffer_roughness, vec2<i32>(floor(coord.xy)), 0).r;
//   // let roughness = 0.1;

//   var color = vec3(0.1) * albedo;
//   for (var i = 0u; i < lights.len; i++) {
//     let light = lights.lights[i];
//     let light_dir = light.position - position;
//     let distance = length(light_dir);
//     // if (distance < light.radius) {
//       let diffuse = max(dot(normal, normalize(light_dir)), 0);
//       let attenuation = 1.0 / (distance * distance);
//       color += normal * albedo * light.color.xyz * light.color.w * attenuation;
//     // }
//   }

//   // HDR tonemapping
//   color = color / (color + vec3(1.0));
//   // gamma correct
//   color = pow(color, vec3(1.0/2.2)); 

//   return vec4(color, 1);
// }

@fragment
fn frag_main(@builtin(position) coord: vec4<f32>) -> @location(0) vec4<f32> {
    let depth = textureLoad(gbuffer_depth, vec2<i32>(floor(coord.xy)), 0);
    if (depth >= 1.0) {
      discard; // Don't light the sky.
    }

    // let position  = textureLoad(gbuffer_position, vec2<i32>(floor(coord.xy)), 0).xyz;
    let albedo    = textureLoad(gbuffe_albedo, vec2<i32>(floor(coord.xy)), 0).rgb;
    let normal    = textureLoad(gbuffer_normal, vec2<i32>(floor(coord.xy)), 0).rgb;
    let metallic  = textureLoad(gbuffer_metallic, vec2<i32>(floor(coord.xy)), 0).r;
    let roughness = textureLoad(gbuffer_roughness, vec2<i32>(floor(coord.xy)), 0).r;
    // let roughness = 0.1;


    // let bufferSize = textureDimensions(gbuffer_depth);
    // let coordUV = coord.xy / vec2<f32>(bufferSize);
    let position = getPosition4(coord.xy, depth);

    let N = normalize(normal);
    let V = normalize(camera.position - position);

    // reflectance equation
    var Lo = vec3(0.0);
    for(var i: u32 = 0; i < lights.len; i++) {
        let light = lights.lights[i];
        let distance = length(light.position - position);
        // if(distance < light.radius) {
          // calculate per-light radiance
          let L = normalize(light.position - position);
          Lo += BRDF(light, albedo, L, V, N, metallic, roughness);
        // }
    }   
    
    // ambient lighting (note that the next IBL tutorial will replace 
    // this ambient lighting with environment lighting).
    let ambient = vec3(0.01) * albedo;

    var color = ambient + Lo;

    // HDR tonemapping
    color = color / (color + vec3(1.0));
    // gamma correct
    color = pow(color, vec3(1.0/2.2)); 

    return vec4(color, 1);
}

fn getPosition4(coord: vec2<f32>, depth: f32) -> vec3<f32>
{
    let  sc = coord*2.0/vec2<f32>(textureDimensions(gbuffer_depth)) - 1.0;
    let ndc = vec4( sc.x, sc.y, 2.0*depth - 1.0, 1.0 );
    var pos = camera.inverse_projection_view * ndc;
         pos /= pos.w;
         pos.w = 1.0;
    return pos.xyz;
}

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
@group(0) @binding(3) var gbuffer_metallic: texture_2d<f32>;
@group(0) @binding(4) var gbuffer_roughness: texture_2d<f32>;
@group(0) @binding(5) var gbuffer_sampler: sampler;
@group(0) @binding(6) var gbuffer_position: texture_2d<f32>;

@group(1) @binding(0) var<uniform> camera: Camera;
@group(1) @binding(1) var<uniform> lights: LightBuffer;

fn worldFromScreenCoord(coord: vec2<f32>, depth_sample: f32) -> vec3<f32> {
  // reconstruct world-space position from the screen coordinate.
  let pos_clip = vec4(coord.x * 2.0 - 1.0, (1.0 - coord.y) * 2.0 - 1.0, depth_sample, 1.0);
  let pos_world_w = camera.inverse_projection_view * pos_clip;
  let pos_world = pos_world_w.xyz / pos_world_w.www;
  return pos_world;
}

@vertex
fn vertex_main(@builtin(vertex_index) vertex_index: u32) -> @builtin(position) vec4<f32> {
  const pos = array(
    vec2(-1.0, -1.0), vec2(1.0, -1.0), vec2(-1.0, 1.0),
    vec2(-1.0, 1.0), vec2(1.0, -1.0), vec2(1.0, 1.0),
  );
  return vec4<f32>(pos[vertex_index], 0.0, 1.0);
}


const PI = 3.14159265359;

// Normal Distribution function --------------------------------------
fn D_GGX(dotNH : f32, roughness : f32) -> f32 {
    var alpha : f32 = roughness * roughness;
    var alpha2 : f32 = alpha * alpha;
    var denom : f32 = dotNH * dotNH * (alpha2 - 1.0) + 1.0;
    return alpha2 / (PI * denom * denom);
}

// Geometric Shadowing function --------------------------------------
fn G_SchlicksmithGGX(dotNL : f32, dotNV : f32, roughness : f32) -> f32 {
    var r : f32 = roughness + 1.0;
    var k : f32 = (r * r) / 8.0;
    var GL : f32 = dotNL / (dotNL * (1.0 - k) + k);
    var GV : f32 = dotNV / (dotNV * (1.0 - k) + k);
    return GL * GV;
}

// Fresnel function ----------------------------------------------------
fn F_Schlick(material_color: vec3<f32>, cosTheta : f32, metallic : f32) -> vec3<f32> {
    var F0 : vec3<f32> = mix(vec3<f32>(0.04), material_color, metallic);
    var F : vec3<f32> = F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
    return F;
}

// Specular BRDF composition --------------------------------------------
fn BRDF(light: LightData, material_color: vec3<f32>, L : vec3<f32>, V : vec3<f32>, N : vec3<f32>, metallic : f32, roughness : f32) -> vec3<f32> {
    var H : vec3<f32> = normalize(V + L);
    var dotNV : f32 = clamp(dot(N, V), 0.0, 1.0);
    var dotNL : f32 = clamp(dot(N, L), 0.0, 1.0);
    var dotLH : f32 = clamp(dot(L, H), 0.0, 1.0);
    var dotNH : f32 = clamp(dot(N, H), 0.0, 1.0);
    var color = vec3<f32>(0.0);
    if(dotNL > 0.0) {
        // D = Normal distribution (Distribution of the microfacets)
        var D : f32 = D_GGX(dotNH, roughness);
        // G = Geometric shadowing term (Microfacets shadowing)
        var G : f32 = G_SchlicksmithGGX(dotNL, dotNV, roughness);
        // F = Fresnel factor (Reflectance depending on angle of incidence)
        var F : vec3<f32> = F_Schlick(material_color, dotNV, metallic);
        var spec : vec3<f32> = (D * F * G) / (4.0 * dotNL * dotNV);
        color += spec * dotNL * light.color.xyz;
    }
    return color;
}
