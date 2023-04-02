extends FloorInParent

@export var screen_offset: Vector2 = Vector2(0.0, 0.0)

func _process(delta):
  super._process(delta)
  $camera.position.x = screen_offset.x * get_viewport().size.x / 16.0
  $camera.position.z = screen_offset.y * get_viewport().size.y / 16.0
