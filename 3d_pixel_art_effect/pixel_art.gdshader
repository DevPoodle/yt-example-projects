shader_type canvas_item;
render_mode skip_vertex_transform, unshaded;

const vec2 target_resolution = vec2(320.0, 180.0);
const float colors_per_channel = 8.0;

uniform sampler2D screen_texture: hint_screen_texture, filter_nearest;

void fragment() {
	vec2 uv = floor(SCREEN_UV * target_resolution) / target_resolution;
	vec3 color = texture(screen_texture, uv).rgb;
	vec3 quantized_color = floor(color * colors_per_channel) / colors_per_channel;
	COLOR = vec4(quantized_color, 1.0);
}