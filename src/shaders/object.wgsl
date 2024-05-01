struct Camera {
    projection: mat4x4<f32>,
    view: mat4x4<f32>,
};

struct Light {
    position: vec3<f32>,
    color: vec4<f32>,
    radius: f32,
};

struct LightList {
    ambient: vec4<f32>, // w is intensity
    lights: array<Light, 10>,
    len: u32,
};

struct MaterialParams {
  metallic: f32,
  roughness: f32,
}

struct InstanceData {
    @location(4) transform_0: vec4<f32>,
    @location(5) transform_1: vec4<f32>,
    @location(6) transform_2: vec4<f32>,
    @location(7) transform_3: vec4<f32>,
    @location(8) normal_0: vec3<f32>,
    @location(9) normal_1: vec3<f32>,
    @location(10) normal_2: vec3<f32>,
};

@group(0) @binding(0) var<uniform> camera: Camera;
@group(0) @binding(1) var<uniform> light: LightList;
@group(0) @binding(2) var<uniform> material_params: MaterialParams;
@group(0) @binding(3) var texture_sampler: sampler;
@group(0) @binding(4) var texture: texture_2d<f32>;
@group(0) @binding(5) var normal_texture: texture_2d<f32>;

struct Output {
    @builtin(position) position: vec4<f32>,
    @location(0) position_world: vec3<f32>,
    @location(1) uv: vec2<f32>,
    @location(2) tangent: vec3<f32>,
    @location(3) bitangent: vec3<f32>,
    @location(4) normal: vec3<f32>,
};

@vertex
fn vertex_main(
    @location(0) position: vec3<f32>,
    @location(1) normal: vec3<f32>, 
    @location(2) uv: vec2<f32>,
    @location(3) tangent: vec4<f32>, 
    instance: InstanceData,
) -> Output {
    let instance_transform = mat4x4(instance.transform_0, instance.transform_1, instance.transform_2, instance.transform_3);
    let instance_normal = mat3x3(instance.normal_0, instance.normal_1, instance.normal_2);
    let position_world = instance_transform * vec4(position, 1);

    var out: Output;
    out.position = camera.projection * camera.view * position_world;
    out.position_world = position_world.xyz;
    out.uv = uv;
    out.normal = normalize(instance_normal * normal);
    out.tangent = normalize(instance_normal * tangent.xyz);
    out.tangent = normalize(out.tangent - dot(out.tangent, out.normal) * out.normal);
    out.bitangent = cross(out.normal, out.tangent) * tangent.w;

    return out;
}

@fragment
fn frag_main(in: Output) -> @location(0) vec4<f32> {
    let albedo = textureSample(texture, texture_sampler, in.uv).xyz;

    let tbn = mat3x3(in.tangent, in.bitangent, in.normal);
    let normal_map = textureSample(normal_texture, texture_sampler, in.uv).xyz * 2.0 - 1.0;
    let bumped_normal = normalize(tbn * normal_map);

    // This is just a transpose. similar to `transpose(camera.view)[3].xyz`
    let camera_position_wolrd = vec3(camera.view[0][3], camera.view[1][3], camera.view[2][3]);
    let view_direction = normalize(camera_position_wolrd - in.position_world);

    var surface_reflection = vec3(0.04); 
    surface_reflection = mix(surface_reflection, albedo, material_params.metallic);

    var color = albedo * light.ambient.rgb * light.ambient.w;
    for (var i: u32 = 0; i < light.len; i++) {
        let light = light.lights[i];

        // calculate per-light radiance
        let light_dir = normalize(light.position - in.position_world);
        let half_light = normalize(view_direction + light_dir);
        let distance = length(light.position - in.position_world);
        let attenuation = 1.0 / (distance * distance);
        let radiance = light.color.xyz * attenuation;

        // Normal Distribution Frensel
        let ndf      = distributionGGX(bumped_normal, half_light, material_params.roughness);   
        let geometry = geometrySmith(bumped_normal, view_direction, light_dir, material_params.roughness);      
        let fresnel  = fresnelSchlick(clamp(dot(half_light, view_direction), 0.0, 1.0), surface_reflection);
           
        let numerator    = ndf * geometry * fresnel; 
        let denominator = 4.0 * max(dot(bumped_normal, view_direction), 0.0) * max(dot(bumped_normal, light_dir), 0.0) + 0.0001; // + 0.0001 to prevent divide by zero
        let specular = numerator / denominator;
        
        // for energy conservation, the diffuse and specular light can't
        // be above 1.0 (unless the surface emits light); to preserve this
        // relationship the diffuse component (kD) should equal 1.0 - fresnel.
        var kD = vec3(1.0) - fresnel;
        // multiply kD by the inverse metalness such that only non-metals 
        // have diffuse lighting, or a linear blend if partly metal (pure metals
        // have no diffuse light).
        kD *= 1.0 - material_params.metallic;	  

        // scale light by NdotL
        let NdotL = max(dot(bumped_normal, light_dir), 0.0);        

        // add to outgoing radiance Lo
        color += (kD * albedo / PI + specular) * radiance * NdotL;
    }
    // HDR tonemapping
    color = color / (color + vec3(1.0));
    // gamma correct
    color = pow(color, vec3(1.0/2.2)); 

    return vec4<f32>(color, 1.0);
}

const PI = 3.14159265359;

fn distributionGGX(normal: vec3<f32>, half_light: vec3<f32>, roughness: f32) -> f32 {
    let a = roughness * roughness;
    let a2 = a * a;
    let NdotH = max(dot(normal, half_light), 0.0);
    let NdotH2 = NdotH * NdotH;

    let nom   = a2;
    var denom = (NdotH2 * (a2 - 1.0) + 1.0);
    denom = PI * denom * denom;

    return nom / denom;
}

fn geometrySchlickGGX(NdotV: f32, roughness: f32) -> f32 {
    let r = (roughness + 1.0);
    let k = (r*r) / 8.0;

    let nom   = NdotV;
    let denom = NdotV * (1.0 - k) + k;

    return nom / denom;
}

fn geometrySmith(normal: vec3<f32>, V: vec3<f32>, light_dir: vec3<f32>, roughness: f32) -> f32 {
    let NdotV = max(dot(normal, V), 0.0);
    let NdotL = max(dot(normal, light_dir), 0.0);
    let ggx2 = geometrySchlickGGX(NdotV, roughness);
    let ggx1 = geometrySchlickGGX(NdotL, roughness);

    return ggx1 * ggx2;
}

fn fresnelSchlick(cosTheta: f32, surface_reflection: vec3<f32>) -> vec3<f32> {
    return surface_reflection + (1.0 - surface_reflection) * pow(clamp(1.0 - cosTheta, 0.0, 1.0), 5.0);
}