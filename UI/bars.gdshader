shader_type canvas_item;

uniform float amount: hint_range(0.0, 1.0, 0.1);
uniform vec4 color: source_color;

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

void fragment() {
	float over_op = 1. - smoothstep(amount, amount + 0.01, UV.x);
	float d = sdBox(2. * UV - 1., vec2(0.5, 0.5)) * over_op;
	float alpha = (1. - d) * over_op;
	COLOR = vec4(color.xyz, alpha);
}