shader_type spatial;
// Prevent the quad from being affected by lighting and fog. This also improves performance.
render_mode unshaded, fog_disabled;


const float ar =  1152. / 648.;
void vertex() {
  POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

uniform sampler2D _screen_texture: hint_screen_texture;
// godot can only use depth buffer from the current viewport
uniform sampler2D depth_tex: hint_depth_texture;
// https://docs.godotengine.org/en/stable/tutorials/shaders/advanced_postprocessing.html
// -- depth buffer video
// https://www.youtube.com/watch?v=wyGWuGQO63Y
void fragment() {
	// depth texture stuff
	//float depth = texture(depth_tex, SCREEN_UV).r;
	ALBEDO = vec3(1., 0., 0.) + texture(_screen_texture, SCREEN_UV).xyz;
	
}