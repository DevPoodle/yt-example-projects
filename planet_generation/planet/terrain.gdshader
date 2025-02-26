shader_type spatial;
render_mode world_vertex_coords;

uniform float specular = 0.8;
uniform float roughness = 0.6;
uniform float radius = 8.0;
uniform float height = 4.0;
uniform sampler2D gradient: repeat_disable;

varying vec4 world_vert;

void vertex() {
	world_vert = inverse(MODEL_MATRIX) * vec4(VERTEX, 1.0);
}

void fragment() {
	SPECULAR = specular;
	ROUGHNESS = roughness;

	float color_uv = (length(world_vert.xyz) - radius) / height;
	ALBEDO = texture(gradient, vec2(color_uv, 0.0)).rgb;
}
