shader_type spatial;
// Prevent the quad from being affected by lighting and fog. This also improves performance.
render_mode unshaded, fog_disabled;

//uniform sampler2D depth_texture : hint_depth_texture;
//uniform sampler2D kaiju_viewport: hint_depth_texture;
//uniform sampler2D viewport_world;

// godot can only use depth buffer from the current viewport
uniform sampler2D kaiju_vieport_texture;
uniform sampler2D _screen_texture: hint_screen_texture;

const float ar =  1152. / 648.;
void vertex() {
  POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

uniform sampler2D depth_tex: hint_depth_texture;
uniform sampler2D noise_tex;
// https://docs.godotengine.org/en/stable/tutorials/shaders/advanced_postprocessing.html

// -- depth buffer video
// https://www.youtube.com/watch?v=wyGWuGQO63Y
void fragment() {
	// depth texture stuff
	float depth = texture(depth_tex, SCREEN_UV).r;
	

	vec2 _kaiju_uv = vec2(ar, 1.) * (vec2(UV.x, -UV.y) - vec2(0.5)) + 0.5;
	vec4 kaiju_viewport_sample = texture(kaiju_vieport_texture, _kaiju_uv);
	float kaiju_viewport_mask = smoothstep(0.01, 1., kaiju_viewport_sample.r);
	
	// noise_tex
	vec4 noise_tex_sample = texture(noise_tex, 1.5 * UV);
	float offset = (1. + noise_tex_sample.r) * 0.05 * kaiju_viewport_mask;
	ALBEDO = texture(_screen_texture, SCREEN_UV + offset).xyz;
	
}