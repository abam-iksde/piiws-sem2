shader_type canvas_item;

const vec3[] colors = {
  vec3(0.0, 0.0, 1.0),
  vec3(0.0, 0.478, 1.0),
  vec3(0.0, 0.749, 1.0),
  vec3(0.565, 0.902, 1.0),
  vec3(0.0, 0.749, 1.0),
  vec3(0.0, 0.478, 1.0)
};

void fragment() {
  if (texture(TEXTURE, UV).a < 0.5) discard;
  COLOR = vec4(colors[int(TIME * 6.0) % 6], 1.0);
}
