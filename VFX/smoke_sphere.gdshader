shader_type spatial;

render_mode unshaded;
uniform sampler2D perlin_noise_tex: repeat_enable;
uniform sampler2D surface_noise_tex: repeat_enable;

mat2 rot(float angle){
	return mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
}

float EaseInCubic(float x)
{
   return x * x * x;
}

float EaseOutCubic(float x)
{ 
   return 1.0 - pow(1.0 - x,3.0);
}

float EaseInSine(float x)
{
    return 1.0 - cos((x * PI) / 2.0);
}

void vertex() {
	//float _sign = sign(VERTEX.x);
	vec3 disp = 0.2 * texture(perlin_noise_tex, 0.2 * NORMAL.xz - 0.3 * TIME).xyz;
	VERTEX += NORMAL * disp;
}

uniform vec4 base_color: source_color;
uniform vec4 darker_base_color: source_color;
uniform vec4 dark_color: source_color;
//uniform float amount_control: hint_range(0.0, 1.0, 0.05);
//uniform float _alpha: hint_range(0.0, 1.0, 0.05);

// -----------------------------------------------------------------------------
// proximity fade shader
// https://gist.github.com/elementbound/21b34cbc3f16987393053142c1dc6c73
// -------------------------------------------------------------------------------------------------
void fragment() {
	//float _amount_from_particle_lifetime = COLOR.w;
	vec4 extra_noise_sample = texture(perlin_noise_tex, UV - vec2(0., 0.4 * TIME));
	// texture sample value -> gradient
	vec4 voronoi_sample = texture(surface_noise_tex, rot(0.4 * TIME ) * 0.7 * UV - 0.1 * TIME);
	float adjusted_vor_noise_sample = EaseInSine(voronoi_sample.r) ;//pow(voronoi_sample.r, 3);
	//float _amount = smoothstep(amount_control, amount_control + 0.2 , EaseOutCubic(voronoi_sample.r));
	float _amount = smoothstep(COLOR.r, COLOR.r + 0.2 , EaseOutCubic(voronoi_sample.r));

	float zero_to_1 = 0.5 * (sin(3. * TIME) + 1.);
	vec3 explosion_col = mix(darker_base_color.xyz, base_color.xyz, adjusted_vor_noise_sample * _amount * zero_to_1);
	//vec3 explosion_col = mix(darker_base_color.xyz, base_col_with_amount, adjusted_vor_noise_sample);
	
	ALBEDO =  mix(dark_color.xyz, 
				 _amount * explosion_col,
				 adjusted_vor_noise_sample) * 1.;
	ALPHA = smoothstep(COLOR.a, COLOR.a + 0.2, extra_noise_sample.r);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
