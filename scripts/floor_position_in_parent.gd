extends Node3D

func _process(delta):
  if not GameSettings.pixelated_look:
    return
  var parent_position = get_node('..').global_position
  global_position = Vector3(
    floor(parent_position.x*16.0)/16.0,
    global_position.y,
    floor(parent_position.z*16.0)/16.0
  )
