shader_type spatial;

render_mode unshaded, cull_disabled;
void vertex() {
	// Called for every vertex the material is visible on.
}

uniform sampler2D streak_texture_atlas;
uniform sampler2D fade_tex: repeat_enable;
uniform vec4 color: source_color;
void fragment() {
	float rnd = COLOR.r;
	ALBEDO = COLOR.xyz;
	// rnd_val = COLOR.r;
	float x = 0.25 * floor(4. * rnd); // random 0.25, 0.5, 0.75, 1.
	vec4 streak = texture(streak_texture_atlas,  vec2(0.25 *  UV.x + x, UV.y));
	ALBEDO = streak.xyz * color.xyz;

	float fade_tex_sample = texture(fade_tex, UV).r;
	float fade = smoothstep(COLOR.w, COLOR.w + 0.1, fade_tex_sample);
	ALPHA = fade * smoothstep(0., 0.5, streak.r);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
