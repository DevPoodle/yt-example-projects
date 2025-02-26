shader_type spatial;

uniform float specular = 0.9;
uniform float roughness = 0.3;
uniform float radius = 8.0;
uniform float level = 10.0;
uniform sampler2D gradient: repeat_disable;
uniform sampler2D depth_texture: hint_depth_texture, repeat_disable;

float get_linear_depth(vec2 uv, mat4 inv_projection_matrix) {
	float depth = texture(depth_texture, uv).r;
	vec4 upos = inv_projection_matrix * vec4(uv * 2.0 - 1.0, depth, 1.0);
	vec3 pixel_position = upos.xyz / upos.w;
	return pixel_position.z;
}

void fragment() {
	ROUGHNESS = roughness;
	SPECULAR = specular;

	float depth_difference = VERTEX.z - get_linear_depth(SCREEN_UV, INV_PROJECTION_MATRIX);
	float color_uv = depth_difference / (level - radius);
	ALBEDO = texture(gradient, vec2(color_uv, 0.0)).rgb;
}
