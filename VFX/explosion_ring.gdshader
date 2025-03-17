shader_type spatial;

render_mode unshaded, cull_disabled;

float EaseOutSine(float x)
{
    return sin((x * PI) / 2.0);
}

void vertex() {
	VERTEX *= 4.;}
	// Billboard Mode: Enabled
	//MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			//MAIN_CAM_INV_VIEW_MATRIX[0],
			//MAIN_CAM_INV_VIEW_MATRIX[1],
			//MAIN_CAM_INV_VIEW_MATRIX[2],
			//MODEL_MATRIX[3]);
	//MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
//}

uniform sampler2D noise: repeat_enable;
uniform vec4  color: source_color;
uniform vec4 dulling_color: source_color;
uniform float alpha_t: hint_range(0.0, 1.0, 0.1);
const float outer_rad = 0.93;

void fragment() {
	vec2 uv = 2. * UV - 1.;
	vec2 domain = vec2(atan(uv.y, uv.x), length(uv));
	vec4 noise_for_rings = texture(noise, vec2(0.1, 1.) * domain - vec2(0., TIME));
	float interpol = smoothstep(alpha_t, 1., EaseOutSine(noise_for_rings.r));
	float circ_mask = 1. - smoothstep(0.8, 1., domain.y);
	ALPHA *= interpol * circ_mask;
	ALPHA *= smoothstep(0., 0.2, -uv.y);
	ALBEDO = interpol * mix(color.xyz, dulling_color.xyz, alpha_t);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
