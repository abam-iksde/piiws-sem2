extends FloorInParent

const SCREEN_WIDTH_IN_TILES = 426.0 / 16.0
const SCREEN_HEIGHT_IN_TILES = 320.0 / 16.0

@export var screen_offset: Vector2 = Vector2(0.0, 0.0)

func _process(delta):
  super._process(delta)
  $camera.position.x = screen_offset.x * SCREEN_WIDTH_IN_TILES
  $camera.position.z = screen_offset.y * SCREEN_HEIGHT_IN_TILES
