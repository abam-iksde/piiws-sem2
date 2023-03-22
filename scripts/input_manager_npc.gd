class_name InputManagerNPC
extends Object

const HANDBRAKE_THRESHOLD = 10

var metadata
var node
var path_map

func get_target_direction():
  var local_position = node.global_position - path_map.global_position
  var grid_position = path_map.local_to_map(local_position)
  var item = path_map.get_cell_item(grid_position)
  match item:
    0:
      return Angles.right
    1:
      return Angles.left
    2:
      return Angles.up
    3:
      return Angles.down
    4:
      return Angles.diagonal_down_right
    5:
      return Angles.diagonal_up_left
    6:
      return Angles.diagonal_up_right
    7:
      return Angles.diagonal_down_left
  return null

func get_input():
  var steering = 0
  var handbrake = 0
  var target_direction = get_target_direction()
  if target_direction != null:
    var sprite = node.get_node('sprite')
    var angle_difference = lerp_angle(sprite.rotation.y, target_direction, PI) - sprite.rotation.y
    if angle_difference > 0:
      steering = 1
    elif angle_difference < 0:
      steering = -1
    handbrake = abs(angle_difference) > deg_to_rad(75) and node.velocity.length_squared() > HANDBRAKE_THRESHOLD * HANDBRAKE_THRESHOLD
  return {
    'acceleration': 1,
    'steering': steering,
    'handbrake': handbrake,
  }

func _init(_metadata, _node):
  metadata = _metadata
  node = _node
  path_map = node.get_node('../path_map')
