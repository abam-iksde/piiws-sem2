extends Node3D

const BOOST_DURATION = 3

var vehicle
var base_max_speed

var boost_time = 0

func _ready():
  vehicle = get_node('../..')
  base_max_speed = vehicle.max_speed

func activate():
  vehicle.movement_mode = vehicle.MovementMode.NORMAL
  boost_time = BOOST_DURATION
  vehicle.max_speed = calculate_speed()
  vehicle.scalar_speed = vehicle.max_speed

func calculate_speed():
  return base_max_speed + base_max_speed*0.5 * (boost_time/BOOST_DURATION)

func _physics_process(delta):
  if boost_time > 0:
    boost_time -= delta
    if boost_time <= 0:
      vehicle.max_speed = base_max_speed
      return
    vehicle.max_speed = calculate_speed()
