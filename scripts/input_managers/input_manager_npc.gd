class_name InputManagerNPC
extends Object

const HANDBRAKE_THRESHOLD = 10

var metadata
var node

var overlapping_boxes = {}

func angle_to_angle(from, to):
  return fposmod(to-from + PI, PI*2) - PI

func get_target_direction():
  for box in overlapping_boxes:
    if (node.global_position.x >= box.global_position.x-1.0
    and node.global_position.x <= box.global_position.x+1.0
    and node.global_position.z >= box.global_position.z-1.0
    and node.global_position.z <= box.global_position.z+1.0):
      return box.direction
  return 0

func get_input():
  var steering = 0
  var handbrake = 0
  var target_direction = get_target_direction()
  if target_direction != null:
    var sprite = node.get_node('sprite')
    var angle_difference = angle_to_angle(sprite.rotation.y, target_direction)
    if angle_difference > 0:
      steering = 1
    elif angle_difference < 0:
      steering = -1
    handbrake = abs(angle_difference) > deg_to_rad(50) and node.velocity.length_squared() > HANDBRAKE_THRESHOLD * HANDBRAKE_THRESHOLD
  return {
    acceleration = 1,
    steering = steering,
    handbrake = handbrake,
    power_up = false,
  }

func _init(_metadata, _node):
  metadata = _metadata
  node = _node
