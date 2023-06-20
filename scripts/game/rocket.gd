extends Area3D

const speed = 30

var shooter

func on_body_enter(body):
  if body == shooter:
    return
  var explosion = preload('res://scenes/prefabs/game/explosion.tscn').instantiate()
  get_parent().add_child(explosion)
  explosion.global_position = global_position
  queue_free()

func _ready():
  connect('body_entered', on_body_enter)

func _physics_process(delta):
  position += Vector3(0, 0, speed * delta).rotated(Vector3(0, 1, 0), rotation.y)
