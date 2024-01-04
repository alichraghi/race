struct UBO {
    projection: mat4x4<f32>,
    view: mat4x4<f32>,
    model: mat4x4<f32>,
    normal: mat3x3<f32>,
    ambient_light_color: vec4<f32>, // w is intensity
    light_position: vec3<f32>,
    light_color: vec4<f32>,
};

@group(0) @binding(0) var<uniform> ubo: UBO;

struct Output {
    @builtin(position) position: vec4<f32>,
    @location(0) color: vec3<f32>,
    @location(1) position_world: vec3<f32>,
    @location(2) normal_world: vec3<f32>,
};

        
@vertex
fn vertex_main(
    @location(0) position: vec3<f32>,
    @location(1) color: vec3<f32>, 
    @location(2) normal: vec3<f32>, 
    @location(3) uv: vec2<f32>
) -> Output {
    let position_world = ubo.model * vec4(position, 1);

    var output: Output;
    output.position = ubo.projection * ubo.view * position_world;
    output.color = color;
    output.position_world = position_world.xyz;
    output.normal_world = normalize(ubo.normal * normal);
    return output;
}

@fragment
fn frag_main(in: Output) -> @location(0) vec4<f32> {
    let direction_to_light = normalize(ubo.light_position - in.position_world);
    let attenuation = 1.0 / dot(direction_to_light, direction_to_light); // distance squared
    let light_color = ubo.light_color.xyz * ubo.light_color.w * attenuation;
    let ambient_light = ubo.ambient_light_color.xyz * ubo.ambient_light_color.w;
    let diffuse_light = light_color * max(dot(normalize(in.normal_world), normalize(direction_to_light)), 0);
    let color = (diffuse_light + ambient_light) * in.color;
    return vec4(color, 1);
}