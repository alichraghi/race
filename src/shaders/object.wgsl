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
    ambient_color: vec4<f32>, // w is intensity
    lights: array<Light, 10>,
    len: u32,
};

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
@group(0) @binding(2) var diffuse_sampler: sampler;
@group(0) @binding(3) var texture: texture_2d<f32>;

struct Output {
    @builtin(position) position: vec4<f32>,
    @location(0) color: vec3<f32>,
    @location(1) uv: vec2<f32>,
    @location(2) position_world: vec3<f32>,
    @location(3) normal_world: vec3<f32>,
};
        
@vertex
fn vertex_main(
    @location(0) position: vec3<f32>,
    @location(1) color: vec3<f32>, 
    @location(2) normal: vec3<f32>, 
    @location(3) uv: vec2<f32>,
    instance: InstanceData,
) -> Output {
    let instance_transform = mat4x4(instance.transform_0, instance.transform_1, instance.transform_2, instance.transform_3);
    // TODO: what's this? delete it?
    let instance_normal = mat3x3(instance.normal_0, instance.normal_1, instance.normal_2);
    let position_world = instance_transform * vec4(position, 1);

    var output: Output;
    output.position = camera.projection * camera.view * position_world;
    output.color = color;
    output.uv = uv;
    output.position_world = position_world.xyz;
    output.normal_world = normalize(instance_normal * normal);

    return output;
}

@fragment
fn frag_main(in: Output) -> @location(0) vec4<f32> {
    var diffuse_light = light.ambient_color.xyz * light.ambient_color.w;
    var specular_light = vec3(0.0);
    let surface_normal = normalize(in.normal_world);

    // This is just a transpose. similar to `transpose(camera.view)[3].xyz`
    let camera_position_wolrd = vec3(camera.view[0][3], camera.view[1][3], camera.view[2][3]);
    let view_direction = normalize(camera_position_wolrd - in.position_world);

    for (var i: u32 = 0; i < light.len; i++) {
        let light = light.lights[i];
        var direction_to_light = light.position.xyz - in.position_world;
        let attenuation = 1.0 / dot(direction_to_light, direction_to_light); // distance squared
        direction_to_light = normalize(direction_to_light);

        let cos_ang_incidence = max(dot(surface_normal, direction_to_light), 0);
        let intensity = light.color.xyz * light.color.w * attenuation;

        diffuse_light += intensity * cos_ang_incidence;

        // Specular lighting
        let half_angle = normalize(direction_to_light + view_direction);
        var blinn_term = dot(surface_normal, half_angle);
        blinn_term = clamp(blinn_term, 0, 1);
        blinn_term = pow(blinn_term, 32); // higher -> shareper highlight
        specular_light += intensity * blinn_term;
    }
  
    let color = textureSample(texture, diffuse_sampler, in.uv).xyz;
    return vec4(diffuse_light * color + specular_light * in.color, 1.0);
}