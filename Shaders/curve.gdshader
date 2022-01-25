shader_type canvas_item;


uniform float curve: hint_range(-0.5, 0.5);

uniform sampler2D vignette;
uniform float zoom: hint_range(-5.0, 5.0);
uniform vec2 tiled_factor = vec2(5.0, 5.0);

void fragment() {
//	vec2 tiled_uvs = UV * tiled_factor;
//	COLOR = vec4(tiled_uvs = UV * tiled_factor, 0.0, 1.0);
	vec3 vignette_color = texture(vignette, UV).rgb;
	// Screen texture stores gaussian blurred copies on mipmaps.
//	COLOR.rgb = texture(TEXTURE, UV).rgb
	COLOR.rgb = textureLod(SCREEN_TEXTURE, vec2(SCREEN_UV.x * zoom + tiled_factor.x, SCREEN_UV.y * zoom + vignette_color.r * curve + tiled_factor.y) , 0.0).rgb;
//	COLOR.r = textureLod(SCREEN_TEXTURE, vec2(SCREEN_UV.x + vignette_color.r * amount * -1.0 , SCREEN_UV.y + vignette_color.r * amount * -1.0 ), 0).r;
//	COLOR.g = textureLod(SCREEN_TEXTURE, vec2(SCREEN_UV.x + vignette_color.r * amount * 0.0 , SCREEN_UV.y + vignette_color.r * amount * 1.0), 0).g;
//	COLOR.b = textureLod(SCREEN_TEXTURE, vec2(SCREEN_UV.x + vignette_color.r * amount * 1.0, SCREEN_UV.y + vignette_color.r * amount * 0.0 ), 0).b;
//	COLOR.rgb *= texture(vignette, UV).rgb;
}