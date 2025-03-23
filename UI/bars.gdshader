shader_type canvas_item;

uniform float amount: hint_range(0.0, 1.0, 0.1);
uniform vec4 color: source_color;

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

uniform float _out_of = 1.0;
void fragment() {
	vec2 uv = 2. * UV - 1.;
	float over_op = 1. - smoothstep(amount, amount + 0.01, UV.x);
	float d = sdBox(uv, vec2(0.5, 0.5)) * over_op;
	
	float out_of_d =  (1. - abs(sdBox(uv, vec2(0.5, 0.5)) - 0.8)) * _out_of;
	
	vec3 out_of_col = (vec3(1., 0., 0.) + 0.1 * sin(15. * TIME)) * out_of_d;
	float alpha = (1. - d) * over_op + _out_of;
	
	vec3 col = color.xyz * (1. - _out_of) + out_of_col;
	COLOR = vec4(col, alpha);
}