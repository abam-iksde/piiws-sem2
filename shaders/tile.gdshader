shader_type spatial;
render_mode unshaded;

uniform sampler2D tileset_texture: filter_nearest, source_color;
uniform ivec2 tile_offset;
uniform ivec2 tile_size;

const float margin = 0.05;

void vertex() {
  ivec2 i_tileset_size = textureSize(tileset_texture, 0);
  vec2 tileset_size = vec2(float(i_tileset_size.x), float(i_tileset_size.y));
  UV = (UV * vec2((float(tile_size.x)-margin) / tileset_size.x, (float(tile_size.y)-margin) / tileset_size.y) + vec2((float(tile_offset.x)+margin) / tileset_size.x, (float(tile_offset.y)+margin) / tileset_size.y));
}

void fragment() {
  vec4 color = texture(tileset_texture, UV);
  if (color.a < 0.5) {
    discard;
  }
	ALBEDO = color.rgb;
}
