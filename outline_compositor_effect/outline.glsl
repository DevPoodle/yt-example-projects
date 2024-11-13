#[compute]
#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) readonly buffer Params {
	vec2 raster_size;
	vec2 reserved;
	mat4 inv_proj_mat;
} params;

layout(rgba16f, set = 0, binding = 1) uniform image2D color_image;
layout(set = 0, binding = 2) uniform sampler2D depth_texture;

const vec2 offset = vec2(0.0001);
const float sample_size = 5.0;

float get_linear_depth(vec2 uv) {
	float raw_depth = texture(depth_texture, uv).r;
	vec3 ndc = vec3(uv * 2.0 - 1.0, raw_depth);
	vec4 view = params.inv_proj_mat * vec4(ndc, 1.0);
	view.xyz /= view.w;
	return -view.z;
}

void main() {
	vec2 size = params.raster_size;
	ivec2 uv = ivec2(gl_GlobalInvocationID.xy);
	vec2 uv_normalized = uv / size;
	
	if (uv.x >= size.x || uv.y >= size.y) {
		return;
	}
	
	vec4 color = imageLoad(color_image, uv);
	float depth = get_linear_depth(uv_normalized + offset);
	float depth_border = 1.0;
	
	for (float x = -sample_size; x <= sample_size; x++) {
		for (float y = -sample_size; y <= sample_size; y++) {
			if (length(vec2(x, y)) > sample_size)
				continue;
			float offset_depth = get_linear_depth(uv_normalized + vec2(x, y) / size + offset);
			if (abs(depth - offset_depth) > 1.0) {
				depth_border = 0.0;
				break;
			}
		}
		if (depth_border == 0.0)
			break;
	}
	
	imageStore(color_image, uv, vec4(color.rgb * depth_border, 1.0));
}