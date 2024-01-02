@group(0) @binding(0) var<uniform> ubo: UBO;

struct UBO {
    projection: mat4x4<f32>,
    view: mat4x4<f32>,
    model: mat4x4<f32>,
};

struct Output {
    @builtin(position) pos: vec4<f32>,
    @location(1) color: vec3<f32>,
};
        
@vertex
fn vertex_main(@location(0) pos: vec3<f32>, @location(1) color: vec3<f32>) -> Output {
    var output: Output;
    output.pos = ubo.projection * ubo.view * ubo.model * vec4(pos, 1);
    output.color = color;
    return output;
}

@fragment
fn frag_main(@location(1) color: vec3<f32>) -> @location(0) vec4<f32> {
    return vec4(color, 1);
}