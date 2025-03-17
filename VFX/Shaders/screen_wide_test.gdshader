shader_type canvas_item;

uniform sampler2D _screen_texture: hint_screen_texture;
void fragment() {
	vec3 col = texture(_screen_texture, SCREEN_UV).xyz;
	COLOR = vec4(col, 1.);
}
