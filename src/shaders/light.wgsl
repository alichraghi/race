struct Camera {
    projection: mat4x4<f32>,
    view: mat4x4<f32>,
};

struct Light {
    position: vec3<f32>,
    color: vec4<f32>,
    radius: f32,
};

@group(0) @binding(0) var<uniform> camera: Camera;
@group(0) @binding(1) var<uniform> light: Light;

@vertex
fn vertex_main(@builtin(vertex_index) vertex_index: u32) -> @builtin(position) vec4<f32> {
    const scale = 0.1;
    const offsets = array(
        // Triangle 1
        vec2(0, 0),
        vec2(1, 0),
        vec2(0.5, 0.86602540378),
        
        // Triangle 2
        vec2(0, 0),
        vec2(0.5, 0.86602540378),
        vec2(-0.5, 0.86602540378),
        
        // Triangle 3
        vec2(0, 0),
        vec2(-0.5, 0.86602540378),
        vec2(-1, 0),
        
        // Triangle 4
        vec2(0, 0),
        vec2(-1, 0),
        vec2(-0.5, -0.86602540378),
        
        // Triangle 5
        vec2(0, 0),
        vec2(-0.5, -0.86602540378),
        vec2(0.5, -0.86602540378),
        
        // Triangle 6
        vec2(0, 0),
        vec2(0.5, -0.86602540378),
        vec2(1, 0)
    );

    let offset = offsets[vertex_index];
    let camera_right_world = vec3(camera.view[0][0], camera.view[1][0], camera.view[2][0]);
    let camera_up_world = vec3(camera.view[0][1], camera.view[1][1], camera.view[2][1]);

    let position_world = light.position
                       + scale * light.radius * offset.x * camera_right_world
                       + scale * light.radius * offset.y * camera_up_world;

    return camera.projection * camera.view * vec4(position_world, 1.0);
}

@fragment
fn frag_main() -> @location(0) vec4<f32> {
    return light.color;
}