shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform float is_leading_heart = 0.;
void fragment() {
	//float zoom = 1.3 + is_leading_heart * 0.1 * sin(5. * TIME);
	float _add = is_leading_heart * 0.1 * sin(5. * TIME);
	//vec2 uv =zoom * (UV - vec2(0.5)) + vec2(0.5);
	COLOR =texture(TEXTURE, UV) + vec4(vec3(_add), 0.);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
