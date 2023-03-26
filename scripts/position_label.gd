extends Label

@export var vehicle: CharacterBody3D

var last_position = 0

func _physics_process(delta):
  if vehicle == null:
    return
  var this_position = Race.get_player_position(vehicle)
  if last_position == this_position:
    return
  
  last_position = this_position
  text = 'pos: ' + str(last_position)
