@group(0) @binding(0) var<uniform> ubo: UBO;

struct UBO {
    transform: mat2x2<f32>,
    offset: vec2<f32>,
    color: vec3<f32>,
};

struct Output {
    @builtin(position) pos: vec4<f32>,
};
        
@vertex fn vertex_main(@location(0) pos: vec2<f32>, @location(1) color: vec3<f32>) -> Output {
    var output: Output;
    output.pos = vec4(ubo.transform * pos + ubo.offset, 0, 1);
    return output;
}

@fragment fn frag_main() -> @location(0) vec4<f32> {
    return vec4(ubo.color, 1);
}