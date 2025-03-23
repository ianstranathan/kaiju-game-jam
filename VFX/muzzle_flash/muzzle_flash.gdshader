shader_type spatial;

render_mode unshaded;

float EaseOutExpo(float x)
{  
  return 1.0 - pow(2.0, -10.0 * x);;
}

uniform float _scale: hint_range(0., 1.0, 0.1);

void vertex() {
	VERTEX *= (1. +  1.4 * mix(0., 4., EaseOutExpo(_scale)));
}

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}


uniform vec4 albedo: source_color;
void fragment() {
	float mask = fresnel(3.0, NORMAL, VIEW);
	float _time_mask = mix(1., mask, EaseOutExpo(_scale));
	ALBEDO = albedo.xyz * _time_mask;
	ALPHA = _time_mask;
}
