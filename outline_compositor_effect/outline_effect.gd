@tool
extends CompositorEffect
class_name OutlineEffect

var rd := RenderingServer.get_rendering_device()
var shader := RID()
var pipeline := RID()
var parameter_storage_buffer := RID()
var depth_sampler := RID()

func _init() -> void:
	var shader_file: RDShaderFile = load("res://outline.glsl")
	var shader_spirv := shader_file.get_spirv()
	shader = rd.shader_create_from_spirv(shader_spirv)
	pipeline = rd.compute_pipeline_create(shader)
	
	var data := PackedFloat32Array()
	data.resize(20)
	data.fill(0)
	var parameter_data := data.to_byte_array()
	parameter_storage_buffer = rd.storage_buffer_create(parameter_data.size(), parameter_data)
	
	var depth_sampler_state := RDSamplerState.new()
	depth_sampler = rd.sampler_create(depth_sampler_state)

func _render_callback(_callback_type: int, render_data: RenderData) -> void:
	var render_scene_buffers: RenderSceneBuffersRD = render_data.get_render_scene_buffers()
	if !render_scene_buffers:
		return
	
	var size := render_scene_buffers.get_internal_size()
	if size.x == 0 or size.y == 0:
		return
	
	var groups: Vector3i = Vector3((size.x - 1.0) / 8.0 + 1.0, (size.y - 1.0) / 8.0 + 1.0, 1.0).floor()
	
	var parameters := PackedFloat32Array([size.x, size.y, 0.0, 0.0])
	var inv_proj_mat := render_data.get_render_scene_data().get_cam_projection().inverse()
	var inv_proj_mat_array := PackedVector4Array([inv_proj_mat.x, inv_proj_mat.y, inv_proj_mat.z, inv_proj_mat.w])
	
	var parameter_data := parameters.to_byte_array()
	parameter_data.append_array(inv_proj_mat_array.to_byte_array())
	rd.buffer_update(parameter_storage_buffer, 0, parameter_data.size(), parameter_data)
	
	var parameter_uniform := RDUniform.new()
	parameter_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	parameter_uniform.binding = 0
	parameter_uniform.add_id(parameter_storage_buffer)
	
	var color_layer_uniform := RDUniform.new()
	color_layer_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	color_layer_uniform.binding = 1
	color_layer_uniform.add_id(render_scene_buffers.get_color_layer(0))
	
	var depth_layer_uniform := RDUniform.new()
	depth_layer_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_SAMPLER_WITH_TEXTURE
	depth_layer_uniform.binding = 2
	depth_layer_uniform.add_id(depth_sampler)
	depth_layer_uniform.add_id(render_scene_buffers.get_depth_layer(0))
	
	var bindings: Array[RDUniform] = [
		parameter_uniform,
		color_layer_uniform,
		depth_layer_uniform
	]
	
	var uniform_set := rd.uniform_set_create(bindings, shader, 0)
	var compute_list := rd.compute_list_begin()
	
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, groups.x, groups.y, groups.z)
	rd.compute_list_end()
	
	rd.free_rid(uniform_set)
