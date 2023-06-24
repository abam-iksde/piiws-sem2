shader_type canvas_item;

uniform sampler2D shine_texture: filter_nearest, repeat_enable;

void fragment() {
  float shinePixel = texture(shine_texture, vec2(FRAGCOORD.x*SCREEN_PIXEL_SIZE.x + TIME, FRAGCOORD.y*SCREEN_PIXEL_SIZE.y)).a;
	vec4 textureColor = texture(TEXTURE, UV);
  if (textureColor.a < 0.5) discard;
  if (shinePixel > 0.5) {
    COLOR = vec4(1.0, 1.0, 1.0, 1.0);
  }
  else {
    COLOR = textureColor;
  }
}
