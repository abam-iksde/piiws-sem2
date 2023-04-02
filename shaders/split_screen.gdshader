shader_type canvas_item;

uniform sampler2D viewport_texture: filter_nearest, repeat_disable;

void fragment() {
	COLOR = texture(TEXTURE, FRAGCOORD.xy * SCREEN_PIXEL_SIZE) * texture(viewport_texture, FRAGCOORD.xy * SCREEN_PIXEL_SIZE);
  if (COLOR.a < 0.5) discard;
}
