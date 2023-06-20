extends Area3D

func explode():
  for body in get_overlapping_bodies():
    if body is Vehicle:
      body.movement_mode = body.MovementMode.SLIDING
      body.velocity += (body.global_position - global_position).normalized() * (2.5 - global_position.distance_to(body.global_position)) * 32

var phase = 0
var time = 0

func _physics_process(delta):
  time += delta
  if time > 0.5:
    queue_free()
  $sprite.frame = int(time * 8) % 4
  if phase != 1:
    if phase == 0:
      phase = 1
    return
  explode()
  phase = 2
