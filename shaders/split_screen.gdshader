shader_type canvas_item;

uniform sampler2D viewport_texture: filter_nearest, repeat_disable;

void fragment() {
  vec2 screen_size = 1.0/SCREEN_PIXEL_SIZE;
  float screen_size_4to3_x = screen_size.y / 320.0 * 426.0;
  vec2 screen_pixel_size_4to3 = vec2(1.0/screen_size_4to3_x, SCREEN_PIXEL_SIZE.y);
  float frag_coord_x = FRAGCOORD.x - (screen_size.x - 1.0/screen_pixel_size_4to3.x)/2.0;
  vec2 frag_coord_4to3 = vec2(frag_coord_x, FRAGCOORD.y);
	COLOR = texture(TEXTURE, frag_coord_4to3 * screen_pixel_size_4to3) * texture(viewport_texture, FRAGCOORD.xy * SCREEN_PIXEL_SIZE);
  if (COLOR.a < 0.5) discard;
}
