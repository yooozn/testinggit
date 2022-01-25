shader_type canvas_item;

uniform float amount: hint_range(0.0, 55.0);
uniform float blur_amount: hint_range(0.0, 55.0);

uniform sampler2D vignette;

void fragment() {
	vec3 vignette_color = texture(vignette, UV).rgb;
	// Screen texture stores gaussian blurred copies on mipmaps.
//	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, vignette_color.r * blur_amount).rgb;
	COLOR.r = textureLod(SCREEN_TEXTURE, vec2(SCREEN_UV.x + vignette_color.r * amount * -1.0 , SCREEN_UV.y + vignette_color.r * amount * -1.0 ), 0).r;
	COLOR.g = textureLod(SCREEN_TEXTURE, vec2(SCREEN_UV.x + vignette_color.r * amount * 0.0 , SCREEN_UV.y + vignette_color.r * amount * 1.0), 0).g;
	COLOR.b = textureLod(SCREEN_TEXTURE, vec2(SCREEN_UV.x + vignette_color.r * amount * 1.0, SCREEN_UV.y + vignette_color.r * amount * 0.0 ), 0).b;
//	COLOR.rgb *= texture(vignette, UV).rgb;
}