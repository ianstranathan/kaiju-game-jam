shader_type spatial;

render_mode unshaded;
uniform sampler2D noise_tex: repeat_enable;

void vertex() {
	float y = 0.5 * VERTEX.y + 0.5;
	float v_x_and_z = mix(0.2, 1., pow(y, 2.));
	vec3 vertex_noise_sample = texture(noise_tex, VERTEX.xy - TIME).xyz;
	VERTEX += NORMAL * 0.3 * vertex_noise_sample;
	
	VERTEX *= vec3(v_x_and_z, 1., v_x_and_z);
	VERTEX.y += pow(y, 2.);
	VERTEX *= 0.75;
}

uniform vec4 color: source_color;
void fragment() {
	float fract_num = 2. + 1.8 * texture(noise_tex, UV - vec2(0., TIME)).r;
	float fract_interpolant = fract_num * UV.y * UV.y ;
	float mask = 1. - fract(fract_interpolant);
	
	
	ALBEDO = color.xyz * mask;
}

