extends SubViewportContainer

func on_screen_resize():
  var screen_size = get_viewport().size
  var camera_size = $world_viewport.get_camera_3d().size
  stretch_shrink = screen_size.y/(camera_size*16)

func on_game_viewport_resize():
  print($world_viewport.size)

func _ready():
  if not GameSettings.pixelated_look:
    return
  get_viewport().connect("size_changed", on_screen_resize)
  on_screen_resize()
  $world_viewport.connect('size_changed', on_game_viewport_resize)
