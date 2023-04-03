extends Sprite2D

@export var camera_screen_offset: Vector2 = Vector2(-0.25, 0.0)
@export var camera_parent: Node3D

func on_resize():
  var viewport_size = get_viewport().size
  global_position = viewport_size / 2.0
  if GameSettings.pixelated_look:
    $viewport.size = Vector2(320.0 / viewport_size.y * viewport_size.x, 320.0)
  else:
    $viewport.size = viewport_size
  scale = Vector2(viewport_size.x, viewport_size.y) / Vector2(texture.get_size().x, texture.get_size().y)

func _ready():
  on_resize()
  get_viewport().connect('size_changed', on_resize)
  $viewport/camera_holder.screen_offset = camera_screen_offset
  $viewport/camera_holder.parent = camera_parent
  
  material = material.duplicate()
  material.set_shader_parameter('viewport_texture', $viewport.get_texture())
