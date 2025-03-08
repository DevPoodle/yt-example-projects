shader_type spatial;

uniform sampler2D texture_x: source_color, repeat_enable;
uniform sampler2D texture_y: source_color, repeat_enable;
uniform sampler2D texture_z: source_color, repeat_enable;

void fragment() {
	vec4 vertex = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	vec3 normal = normalize((INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
	vec3 adjusted_normal = pow(abs(normal), vec3(8.0));
	vec3 weights = adjusted_normal / (adjusted_normal.x + adjusted_normal.y + adjusted_normal.z) * 3.0;
	
	vec2 uv_x = vertex.zy;
	vec2 uv_y = vertex.xz;
	vec2 uv_z = vertex.xy;
	
	float use_y_up = float(normal.y > 0.0);
	
	vec3 color_x = texture(texture_x, uv_x).rgb * weights.x;
	vec3 color_y_up = texture(texture_y, uv_y).rgb * weights.y;
	vec3 color_y_down = texture(texture_x, uv_y).rgb * weights.y;
	vec3 color_z = texture(texture_z, uv_z).rgb * weights.z;
	
	ALBEDO = (color_x + mix(color_y_down, color_y_up, use_y_up) + color_z) / 3.0;
}