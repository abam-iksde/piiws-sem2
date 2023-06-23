extends Area3D

const EXPLOSION_DURATION = 0.5

func explode():
  for body in get_overlapping_bodies():
    if body is Vehicle:
      body.movement_mode = body.MovementMode.SLIDING
      body.velocity += (body.global_position - global_position).normalized() * (2.5 - global_position.distance_to(body.global_position)) * 32

var phase = 0
var time = 0

func _physics_process(delta):
  time += delta
  if time > EXPLOSION_DURATION:
    queue_free()
  $sprite.frame = int(time * (1.0/EXPLOSION_DURATION) * $sprite.hframes) % $sprite.hframes
  if phase != 1:
    if phase == 0:
      phase = 1
    return
  explode()
  phase = 2
