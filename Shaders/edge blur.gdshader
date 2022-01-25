shader_type canvas_item;
uniform float blur_amount: hint_range(0.0, 55.0);
uniform sampler2D vignette;

void fragment() {
	vec3 vignette_color = texture(vignette, UV).rgb;

	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, vignette_color.r * blur_amount).rgb;

}