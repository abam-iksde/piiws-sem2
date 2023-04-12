extends FloorInParent

const SCREEN_HEIGHT_IN_TILES = 320.0 / 16.0

@export var screen_offset: Vector2 = Vector2(0.0, 0.0)

func _process(delta):
  super._process(delta)
  var viewport_size = get_viewport().size
  var screen_width = 320.0/viewport_size.y * viewport_size.x
  $camera.position.x = screen_offset.x * screen_width / 16.0
  $camera.position.z = screen_offset.y * SCREEN_HEIGHT_IN_TILES
