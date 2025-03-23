// NOTE: Shader automatically converted from Godot Engine 4.4.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

mat2 rot(float angle){
	return mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
}

void vertex() {
	VERTEX.xz = rot(TIME) * VERTEX.xz;
	UV = UV * uv1_scale.xy + uv1_offset.xy;
}

void fragment() {
	vec4 albedo_tex = texture(texture_albedo, UV);
	ALBEDO = albedo_tex.r * vec3(1.) + (1. - albedo_tex.r ) * vec3(1., 0., 0.);
}
