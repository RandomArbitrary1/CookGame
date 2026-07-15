shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);

	vec3 inverted = vec3(0.5) - screen_color.rgb;

	COLOR = vec4(inverted, tex_color.a);
}