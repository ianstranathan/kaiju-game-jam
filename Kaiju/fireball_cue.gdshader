shader_type spatial;

render_mode unshaded;

mat2 rot(float angle){
	return mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
}

void vertex()
{
	VERTEX *= 6.0;
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
}

uniform sampler2D star_tex;
uniform vec4 color: source_color;
uniform sampler2D noise: repeat_enable;

void fragment() {
	vec2 _UV = rot(2. * TIME) * (UV - vec2(0.5)) + vec2(0.5);
	float noise_f = texture(noise, UV - vec2(0., TIME)).r;
	float pulse = sin(40. * TIME);
	float pulse_size = mix(0.9, 1.2, (pulse + 1.) / 2.);
	vec4 star_tex_sample = texture(star_tex, (pulse_size * (_UV - vec2(0.5)) + vec2(0.5)) + 0.1 * noise_f);
	ALPHA = star_tex_sample.w * (1. - smoothstep(0.9, 0.95, length(2. * UV - 1.)));
	ALBEDO = color.xyz + 0.5 * pulse;
}

