shader_type canvas_item;

float dot2( in vec2 v ) { return dot(v,v); }

float sdHeart( in vec2 p )
{
    p.x = abs(p.x);

    if( p.y+p.x>1.0 )
        return sqrt(dot2(p-vec2(0.25,0.75))) - sqrt(2.0)/4.0;
    return sqrt(min(dot2(p-vec2(0.00,1.00)),
                    dot2(p-0.5*max(p.x+p.y,0.0)))) * sign(p.x-p.y);
}

uniform float is_leading_heart = 0.;
void fragment() {
	vec2 uv = 2. * UV - 1.;
	uv *= (1.3 + is_leading_heart * 0.2 * sin(5. * TIME));
	uv.y *= -1.;
	uv.y += 0.5;
	uv.x *= 0.9;
	float d = sdHeart(uv);
	vec3 col = vec3(1., 0., 0.);
	col *= 1.0 - exp(-6.0*abs(d));
	COLOR = vec4(col, 1. - smoothstep(0., 0.01, d));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
