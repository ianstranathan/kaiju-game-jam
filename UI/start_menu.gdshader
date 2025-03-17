shader_type canvas_item;

void vertex(){
}

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

uniform vec4 color: source_color;
uniform float is_hovering = 0.0;
void fragment() {
    vec2 uv = 2. * UV - 1.;
	
	uv += sign(uv) * 0.05 * sin(6. * TIME) * is_hovering;
    float dist = 1.0/abs(sdBox(uv, vec2(0.5)) - 0.25);
	dist *= 0.1;
    dist = pow(dist, 0.8);
	
	float offset = step(0.5, is_hovering);
	dist = dist + offset * 0.2 * dist * sin(6. * TIME);
    vec3 col = dist * color.xyz; //vec3(1.0, 0.5, 0.25);
    col = 1.0 - exp( -col );
    COLOR = -vec4(vec3(0.2), 0.) * (1. - offset) + vec4(col, smoothstep(0.3, 1.5 , dist));
}
