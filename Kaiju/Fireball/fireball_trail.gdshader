shader_type spatial;

render_mode cull_disabled, unshaded;

uniform vec4 color: source_color;
uniform sampler2D lightning_tex: repeat_enable;
uniform sampler2D noise_tex: repeat_enable;

mat2 rot(float angle){
	return mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
}

void fragment() {
	vec2 _UV = 0.25 * (UV - vec2(0.5)) + vec2(0.5);

	vec4 noise_sample = texture(noise_tex, UV + vec2(TIME, 0.));
	vec4 lighting_tex_sample = texture(lightning_tex, _UV + vec2(TIME, 0.));
	ALPHA = noise_sample.r * smoothstep(0., 1., lighting_tex_sample.r) * 3. * UV.x;
	ALPHA = clamp(ALPHA, 0., 1.);
	ALBEDO = color.xyz * pow(UV.x, 3);
}
