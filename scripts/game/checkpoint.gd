class_name Checkpoint
extends Area3D

func on_body_enter(body):
  if body is Vehicle:
    if body.next_checkpoint == self:
      body.collect_checkpoint(false)
    elif body.previous_checkpoint == self:
      body.collect_checkpoint(true)

func _ready():
  connect('body_entered', on_body_enter)
