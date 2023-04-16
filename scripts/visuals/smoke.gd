extends Node3D

var emitting = false

func _physics_process(delta):
  $foreground.emitting = emitting
  $background.emitting = emitting
