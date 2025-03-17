shader_type spatial;

render_mode unshaded, cull_disabled;

uniform vec4 color : source_color;
uniform sampler2D noise_tex: repeat_enable;

// ---------------------------------------------------------------
mat2 rot(float angle){
	return mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
}

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

// ---------------------------------------------------------------

void vertex() {
	vec3 vertex_noise_sample = texture(noise_tex, VERTEX.xz - TIME).xyz;
	VERTEX += NORMAL * 0.1 * vertex_noise_sample;
}


void fragment() {
	// fake turbulence
	vec4 fake_turbulence = texture(noise_tex, UV * vec2(1., 0.1) + vec2(0, 0.2 * TIME) );
	fake_turbulence *= smoothstep(0.6, 0.8, UV.y + 0.2 * fake_turbulence.r);
	ALBEDO = color.xyz;
	//ALPHA = smoothstep(0.5, 1, noise_sample.r)
	ALPHA = smoothstep(0.2, 1, fake_turbulence.r) + fake_turbulence.r * fresnel(3.0, NORMAL, VIEW);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
