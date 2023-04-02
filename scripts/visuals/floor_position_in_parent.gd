class_name FloorInParent
extends Node3D

@export var parent: Node3D

func _process(delta):
  if not GameSettings.pixelated_look:
    return
  var _parent = parent
  if _parent == null:
    _parent = get_parent()
  var parent_position = _parent.global_position
  global_position = Vector3(
    floor(parent_position.x*16.0)/16.0,
    global_position.y,
    floor(parent_position.z*16.0)/16.0
  )
