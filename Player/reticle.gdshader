shader_type spatial;
//render_mode unshaded;

//void vertex(){
	//MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
//}

mat2 rot(float angle){
	return mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
}


float sdHexagram( in vec2 p, in float r )
{
    const vec4 k = vec4(-0.5,0.8660254038,0.5773502692,1.7320508076);
    p = abs(p);
    p -= 2.0*min(dot(k.xy,p),0.0)*k.xy;
    p -= 2.0*min(dot(k.yx,p),0.0)*k.yx;
    p -= vec2(clamp(p.x,r*k.z,r*k.w),r);
    return length(p)*sign(p.y);
}

uniform vec4 color: source_color;
void fragment() {
	//vec2 uv = 2. * UV - 1.;
	//uv = rot(TIME) * uv;
	//uv *= 2.;
	//uv *= (1. + 0.1 * sin(10. * TIME));
	//float d = sdHexagram( uv, 0.5 );
    //float b  = 1.0-smoothstep(0.0,0.1, abs(d));
	//ALBEDO =  color.xyz * b;
	//ALBEDOR
	//ALPHA = b;
}