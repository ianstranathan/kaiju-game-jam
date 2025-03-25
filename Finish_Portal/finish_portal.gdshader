shader_type spatial;

render_mode unshaded;
//varying float _dot;
void vertex() {
	VERTEX.y *= (1. + 0.2 * (sin(2. * TIME) + 1.));
	//VERTEX.z *= (1. + 0.2 * (cos(2. * TIME) + 1.));
}

uniform sampler2D noise_tex: repeat_enable;
uniform vec4 albedo: source_color;

void fragment() {
	vec2 uv = 2. * UV - 1.;
	vec4 noise_sample_2 = texture(noise_tex, abs(uv) - 0.2 * TIME);
	vec4 noise_sample = texture(noise_tex, abs(uv) * vec2(0.1 + 0.1 * noise_sample_2.r, 0.5) - vec2(0.1 * TIME, 0.));
	
	float mask = step(0.5, UV.y); // this was just from playing around, looking at uvs
	float _sides = smoothstep(0.5 + 0.05 *  noise_sample_2.r, 0.6, noise_sample.r);
	// ALBEDO = vec3(_sides) * (1. - mask) +  vec3(1., 0., 0.) * mask;
	vec2 cylinder_top_uvs = vec2(-uv.x, uv.y) - 0.5; // again just trial and error
	
	float top_mask = sin(4. * length(10. * cylinder_top_uvs) + 7. * TIME);
	ALBEDO = albedo.xyz * top_mask * mask + albedo.xyz * _sides * (1. - mask);
}
