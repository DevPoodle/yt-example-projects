shader_type canvas_item;

uniform float curvature = 4.0;

void fragment() {
	vec2 centered_uv = SCREEN_UV * 2.0 - 1.0;
	vec2 uv_offset = centered_uv.yx / curvature;
	vec2 warped_uv = centered_uv - centered_uv * uv_offset * uv_offset;
	COLOR = texture(TEXTURE, (warped_uv + 1.0) / 2.0);
}
