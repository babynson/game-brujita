shader_type canvas_item;

uniform float cutoff : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 col = texture(TEXTURE, UV);

    // ruido para desintegración
    float noise = fract(
        sin(dot(UV * 120.0, vec2(12.9898, 78.233))) * 43758.5453
    );

    // cuanto mayor el cutoff, más se "borra"
    if (noise < cutoff) {
        discard;
    }

    // MUY IMPORTANTE: multiplicar por COLOR
    COLOR = col * COLOR;
}
