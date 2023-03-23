extends Node

const right = deg_to_rad(90)
const left = deg_to_rad(-90)
const up = deg_to_rad(180)
const down = 0
const diagonal_down_right = deg_to_rad(45)
const diagonal_up_left = deg_to_rad(-135)
const diagonal_up_right = deg_to_rad(135)
const diagonal_down_left = deg_to_rad(-45)

func get_angle_from_index(_index):
  var index = wrapi(int(_index), 0, 8)
  match index:
    0:
      return right
    1:
      return left
    2:
      return up
    3:
      return down
    4:
      return diagonal_down_right
    5:
      return diagonal_up_left
    6:
      return diagonal_up_right
    7:
      return diagonal_down_left
  # mathematically not allowed to happen,
  # but math sometimes fails
  return 0
