shader_type spatial;

uniform float height = 64.0;
uniform sampler2D color_gradient;
uniform sampler2D normal_map;

void fragment() {
	vec4 world_vertex = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	vec3 model_vertex = (inverse(MODEL_MATRIX) * world_vertex).xyz;
	float gradient_uv = (model_vertex.y / height) + 0.5;
	ALBEDO = texture(color_gradient, vec2(gradient_uv)).rgb;
	NORMAL_MAP = texture(normal_map, UV).xyz;
}