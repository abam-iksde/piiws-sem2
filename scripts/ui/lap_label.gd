extends Label

@export var vehicle: CharacterBody3D

var last_lap = null

func _physics_process(delta):
  if vehicle == null:
    return
  if last_lap == vehicle.lap:
    return
  
  last_lap = vehicle.lap
  text = 'LAP: ' + str(last_lap)
