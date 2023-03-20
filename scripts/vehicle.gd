class_name Vehicle
extends CharacterBody3D

const STEERING_THRESHOLD = 0.2
const DRIFT_EXIT_THRESHOLD = deg_to_rad(15)
const GRIPPING_TIME_AFTER_HIT = 0.3
const GRIPPING_TIME_AFTER_HANDBRAKE = 0.1
const FORCE_HIT_MULTIPLIER = 0.7

@export var max_speed = 20
@export var acceleration = 32
@export var grip = 1
@export var damping = 16

var gripping_time = 0

var scalar_speed = 0

var velocity_last_frame = null

enum MovementMode {
  NORMAL,
  SLIDING,
}

var movement_mode = MovementMode.NORMAL
var slide_steering_multiplier = 1

var input_manager = InputManagerHuman.new('p1')

func normal(delta, input):
  if input['handbrake']:
    slide_steering_multiplier = sign(scalar_speed)
    movement_mode = MovementMode.SLIDING
    gripping_time = GRIPPING_TIME_AFTER_HANDBRAKE
  
  if velocity.length_squared() > STEERING_THRESHOLD:
    $sprite.rotation.y += input['steering'] * sign(scalar_speed) * grip * 3 * delta
  
  scalar_speed += acceleration * input['acceleration'] * delta
  scalar_speed -= sign(scalar_speed) * damping * delta
  if abs(scalar_speed) > max_speed:
    scalar_speed = max_speed * sign(scalar_speed)
  velocity = Vector3(0, 0, scalar_speed).rotated(Vector3(0, 1, 0), $sprite.rotation.y)

func slide(delta, input):
  gripping_time -= delta
  if not input['handbrake']:
    if velocity.angle_to(Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), $sprite.rotation.y)) < DRIFT_EXIT_THRESHOLD:
      if gripping_time <= 0:
        scalar_speed = velocity.length()
        movement_mode = MovementMode.NORMAL
    elif velocity.angle_to(Vector3(0, 0, -1).rotated(Vector3(0, 1, 0), $sprite.rotation.y)) < DRIFT_EXIT_THRESHOLD:
      if gripping_time <= 0:
        scalar_speed = -velocity.length()
        movement_mode = MovementMode.NORMAL
    else:
      gripping_time = max(GRIPPING_TIME_AFTER_HANDBRAKE, gripping_time)
  else:
    gripping_time = max(GRIPPING_TIME_AFTER_HANDBRAKE, gripping_time)
  
  if velocity.length_squared() > STEERING_THRESHOLD:
    $sprite.rotation.y += input['steering'] * grip * 5 * delta * slide_steering_multiplier
  
  velocity += Vector3(0, 0, acceleration * 0.8 * input['acceleration']).rotated(Vector3(0, 1, 0), $sprite.rotation.y) * delta
  velocity -= velocity.normalized() * damping * 1.5 * delta

func check_collisions():
  if get_slide_collision_count() == 0 or velocity.length_squared() < 0.5:
    return
  var collision = get_last_slide_collision()
  velocity = velocity_last_frame.bounce(collision.get_normal()) * FORCE_HIT_MULTIPLIER
  movement_mode = MovementMode.SLIDING
  gripping_time = GRIPPING_TIME_AFTER_HIT
  slide_steering_multiplier = 1

func process_smoke():
  var timer = get_tree().create_timer(0.02)
  timer.connect('timeout', process_smoke)
  if movement_mode != MovementMode.SLIDING:
    return
  for child in %tyres.get_children():
    var instance = preload('res://scenes/prefabs/smoke.tscn').instantiate()
    get_node('..').add_child(instance)
    instance.global_position = child.global_position

func _ready():
  process_smoke.call_deferred()

func _physics_process(delta):
  var input = input_manager.get_input()
  
  match movement_mode:
    MovementMode.NORMAL:
      normal(delta, input)
    MovementMode.SLIDING:
      slide(delta, input)
  
  check_collisions()
  
  if velocity.length_squared() < STEERING_THRESHOLD:
    if movement_mode != MovementMode.NORMAL:
      movement_mode = MovementMode.NORMAL
      scalar_speed = 0
    if input['acceleration'] == 0:
      scalar_speed = 0
  elif velocity.length_squared() > max_speed * max_speed:
    velocity = velocity.normalized() * max_speed
  
  velocity_last_frame = velocity
  move_and_slide()
