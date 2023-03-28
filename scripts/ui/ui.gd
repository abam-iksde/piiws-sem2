extends Control

func on_window_resize():
  var viewport_size = get_viewport().size
  var _scale = viewport_size.y/size.y
  if size.x * _scale > viewport_size.x:
    _scale = viewport_size.x/size.x
  scale = Vector2(_scale, _scale)
  position = (viewport_size/2.0 - Vector2(size.x * _scale, size.y * _scale)/2.0)

func _ready():
  on_window_resize()
  get_viewport().connect('size_changed', on_window_resize)
