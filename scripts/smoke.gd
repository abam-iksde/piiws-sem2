extends Sprite3D

var life_time = 0.5

func _ready():
  rotation_degrees.y = randi() % 4 * 90

func _physics_process(delta):
  life_time -= delta
  if life_time <= 0:
    queue_free()
  var time_spent = (0.5-life_time)/0.5
  frame = min(floor(time_spent * 4), 3)
