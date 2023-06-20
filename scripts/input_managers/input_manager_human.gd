class_name InputManagerHuman
extends Object

var prefix

func _init(_prefix, _node):
  prefix = _prefix

func get_input():
  return {
    acceleration = Input.get_axis(prefix + '_backward', prefix + '_forward'),
    steering = Input.get_axis(prefix + '_right', prefix + '_left'),
    handbrake = Input.is_action_pressed(prefix + '_handbrake'),
    power_up = Input.is_action_just_pressed(prefix + '_power_up'),
  }
