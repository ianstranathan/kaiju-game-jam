shader_type spatial;

render_mode unshaded;
uniform sampler2D tex;

varying float _dot;
void vertex() {
	VERTEX += vec3(0., 0.75, 0.) * (sin(2. * TIME) +1.) / 2.;
}

#define ANG2RAD 3.14  / 180.0
float sdCircle( in vec2 p, in float r ) 
{
    return length(p)-r;
}

mat2 rot(float angle){
	return mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
}

float sdPie(in vec2 p, in vec2 c, in float r ,float rotateTheta)
{ 
    //float roateteRad = rotateTheta * ANG2RAD;
	mat2 rm = rot(rotateTheta * ANG2RAD);
    //mat2 rm = mat2(cos(roateteRad),sin(roateteRad),-sin(roateteRad),cos(roateteRad));
    p = rm * p;
    p.x = abs(p.x);
    float l = length(p) - r;
	float m = length(p - c*clamp(dot(p,c),0.0,r) );
    return max(l,m*sign(c.y*p.x-c.x*p.y));
}

uniform vec4 color: source_color;
void fragment()
{
    vec2 p = 2. * UV - 1.;
	p.x -= 0.5 * TIME;
	p.x = mod( p.x + 0.25, 0.5) - 0.25;
	p.x *= 18./9.;
    float d0 = sdCircle(p,0.12);
    float d1 = sdCircle(p,0.15);
    float d2 = sdCircle(p,0.50);
    float d3 = sdCircle(p,0.50);
    
    float t = 30.0  * ANG2RAD;
    float rd = sdPie(p,vec2(sin(t),cos(t)), 0.5,0.0);
    float rd2 = sdPie(p,vec2(sin(t),cos(t)), 0.5,-120.0);
    float rd3 = sdPie(p,vec2(sin(t),cos(t)), 0.5, 120.0);
    
    vec3 blackColor = vec3(0.000,0.020,0.039) ;
    vec3 yello = vec3(0.949,0.827,0.027);
    
    vec3 col = mix(blackColor,yello,smoothstep(0.0,0.01,rd));
    col = mix(blackColor,col,smoothstep(0.0,0.01,rd2));
    col = mix(blackColor,col,smoothstep(0.0,0.01,rd3));
    
    
    col = mix(col, yello, 1.0-smoothstep(0.0,0.01,d1));
    col = mix(col, blackColor, 1.0-smoothstep(0.0,0.01,d0));
    
    col = mix( col, vec3(0.0), 1.0-smoothstep(0.0,0.03,abs(d3)));
    col = mix( vec3(1.0), col, 1.0-smoothstep(0.0,0.01,d2));
    
	float col_switch = (1. - step(vec3(1.), col).r);
    ALBEDO = col * (col_switch) + (1. - col_switch) * (color.xyz + vec3(0.1, 1., 0.1) * sin(4. * TIME));
	ALPHA = 1.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
