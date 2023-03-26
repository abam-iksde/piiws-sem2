extends Label

@export var vehicle: Vehicle

var done = false

func _physics_process(delta):
  if done or not vehicle.race_done:
    return
  done = true
  if Race.get_player_position(vehicle) == 1:
    text = 'YOU WIN!'
  else:
    text = 'YOU LOSE!'
