shader_type spatial;

render_mode unshaded;

varying float _dot_mask;
void vertex() {
	//VERTEX.y *= 0.2;
	UV = UV * vec3(3., 2., 1.).xy;
	_dot_mask = dot(NORMAL, vec3(0., 0., 1.));
}

uniform sampler2D tex;

uniform vec4 glow_color: source_color;
void fragment() {
	vec2 uv = 2. * UV - 1.;
	uv *= 2.5;
	float x = 10. * abs(0.1 * uv.y) + uv.x;
	float mask = abs(fract(x) - 0.5);

	float _id = floor(x + 0.5);
	float _alternating_color_pick = abs(sin(_id * PI/2.)); // 0 or 1
	vec3 _glow = glow_color.xyz + 0.75 * sin(5. * TIME);
	vec3 col = mix(_glow, vec3(1., 0., 0.), _alternating_color_pick);

	ALBEDO = col * mask; // texture(tex, UV).xyz;
	ALPHA = _dot_mask;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
