class_name DirectionBox
extends Area3D

var direction

func on_body_enter(body):
  if body is Vehicle:
    if body.input_manager is InputManagerNPC:
      body.input_manager.overlapping_boxes[self] = true

func on_body_exit(body):
  if body is Vehicle:
    if body.input_manager is InputManagerNPC:
      body.input_manager.overlapping_boxes.erase(self)

func _ready():
  connect('body_entered', on_body_enter)
  connect('body_exited', on_body_exit)
