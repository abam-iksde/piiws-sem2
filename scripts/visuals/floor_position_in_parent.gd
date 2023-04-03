class_name FloorInParent
extends Node3D

@export var parent: Node3D

func floor_if_pixelated(value):
  return floor(value) if GameSettings.pixelated_look else value

func _process(delta):
  var _parent = parent
  if _parent == null:
    _parent = get_parent()
  var parent_position = _parent.global_position
  global_position = Vector3(
    floor_if_pixelated(parent_position.x*16.0)/16.0,
    global_position.y,
    floor_if_pixelated(parent_position.z*16.0)/16.0
  )
