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

struct InstanceData {
    @location(3) transform_0: vec4<f32>,
    @location(4) transform_1: vec4<f32>,
    @location(5) transform_2: vec4<f32>,
    @location(6) transform_3: vec4<f32>,
    @location(7) normal_0: vec3<f32>,
    @location(8) normal_1: vec3<f32>,
    @location(9) normal_2: vec3<f32>,
};

struct Output {
    @builtin(position) position: vec4<f32>,
    @location(0) position_world: vec3<f32>,
    @location(1) uv: vec2<f32>,
    @location(2) normal: vec3<f32>,
};

const PI = radians(180);

@group(0) @binding(0) var<uniform> camera: Camera;
@group(0) @binding(1) var<uniform> light_list: LightList;
@group(0) @binding(2) var texture_sampler: sampler;
@group(0) @binding(3) var albedo_texture: texture_2d<f32>;
@group(0) @binding(4) var normal_texture: texture_2d<f32>;

@vertex
fn vertex_main(
    @location(0) position: vec3<f32>,
    @location(1) normal: vec3<f32>, 
    @location(2) uv: vec2<f32>,
    instance: InstanceData,
) -> Output {
    let instance_transform = mat4x4(instance.transform_0, instance.transform_1, instance.transform_2, instance.transform_3);
    let instance_normal = mat3x3(instance.normal_0, instance.normal_1, instance.normal_2);
    let position_world = instance_transform * vec4(position, 1);

    var out: Output;
    out.position = camera.projection * camera.view * position_world;
    out.position_world = position_world.xyz;
    out.uv = uv;
    out.normal = normalize((instance_transform * vec4(normal, 0)).xyz);

    return out;
}

@fragment
fn frag_main(in: Output) -> @location(0) vec4<f32> {
    let albedo = textureSample(albedo_texture, texture_sampler, in.uv).xyz;

    // This is just a transpose. similar to `transpose(camera.view)[3].xyz`
    let camera_position_wolrd = vec3(camera.view[0][3], camera.view[1][3], camera.view[2][3]);
    let view_dir = normalize(camera_position_wolrd - in.position_world);

    var color = albedo;
    var diffuse_light = light_list.ambient.rgb * light_list.ambient.a;
    var specular_light = vec3(0.0);

    for (var i: u32 = 0; i < light_list.len; i++) {
        let light = light_list.lights[i];

        // if (distance > light.radius) {
        //     continue;
        // }

        // diffuse 
        var direction_to_light = light.position.xyz - in.position_world;
        let attenuation = 1.0 / dot(direction_to_light, direction_to_light); // distance squared
        direction_to_light = normalize(direction_to_light);

        let cos_ang_incidence = max(dot(in.normal, direction_to_light), 0);
        let intensity = light.color.xyz * light.color.w * attenuation;

        diffuse_light += intensity * cos_ang_incidence;
        
        // Specular lighting
        let half_angle = normalize(direction_to_light + view_dir);
        var blinn_term = dot(in.normal, half_angle);
        blinn_term = clamp(blinn_term, 0, 1);
        blinn_term = pow(blinn_term, 32); // higher -> shareper highlight
        specular_light += intensity * blinn_term;
    }

    return vec4(color * diffuse_light + specular_light, 1.0);
}
