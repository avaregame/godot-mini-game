shader_type canvas_item;

uniform vec4 light_color : source_color = vec4(1.0, 0.6, 0.2, 1.0);
uniform float intensity : hint_range(0.0, 5.0) = 2.0;

void fragment() {
    vec2 uv = UV - 0.5;
    float distance = length(uv);
    float falloff = 1.0 - smoothstep(0.3, 0.5, distance);

    COLOR = light_color * falloff * intensity;
    COLOR.a = falloff;
}