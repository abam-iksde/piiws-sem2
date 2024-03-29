class_name Vehicle
extends CharacterBody3D

@export var texture: Texture = null

@export_enum('human', 'npc') var control_type = 'human'
@export var control_metadata: String = ''

const STEERING_THRESHOLD = 0.1
const DRIFT_EXIT_THRESHOLD = deg_to_rad(15)
const GRIPPING_TIME_AFTER_HIT = 0.3
const GRIPPING_TIME_AFTER_HANDBRAKE = 0.1
const FORCE_HIT_MULTIPLIER = 0.7
const VEHICLE_COLLISION_BASE_FORCE = 10

const NORMAL_GRIP_MULTIPLIER = 3
const SLIDING_GRIP_MULTIPLIER = 5
const SLIDING_ACCELERATION_MULTIPLIER = 0.85
const COLLISION_VELOCITY_MULTIPLIER = 0.7
const SLIDING_DAMPING_MULTIPLIER = 1.5

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

var id

var movement_mode = MovementMode.NORMAL
var slide_steering_multiplier = 1

var input_manager
var is_human

var previous_checkpoint = null
var next_checkpoint = null
var lap = null
var race_done = false

var power_up = null

func collect_checkpoint(previous):
  var next_checkpoint_data = Race.next_checkpoint(previous_checkpoint if previous else next_checkpoint, lap)
  var previous_checkpoint_data = Race.next_checkpoint(previous_checkpoint if previous else next_checkpoint, lap, -1)
  next_checkpoint = next_checkpoint_data.checkpoint
  lap = previous_checkpoint_data.lap if previous else next_checkpoint_data.lap
  previous_checkpoint = previous_checkpoint_data.checkpoint

func finish_race():
  init_control('npc', '')
  race_done = true

func init_control(control_type, control_metadata):
  match control_type:
    'human':
      input_manager = InputManagerHuman.new(control_metadata, self)
      is_human = true
    'npc':
      input_manager = InputManagerNPC.new(control_metadata, self)
      is_human = false

func mode_handler_normal(delta, input):
  if input.handbrake:
    slide_steering_multiplier = sign(scalar_speed)
    movement_mode = MovementMode.SLIDING
    gripping_time = GRIPPING_TIME_AFTER_HANDBRAKE
  
  if velocity.length_squared() > STEERING_THRESHOLD:
    $sprite.rotation.y += input.steering * sign(scalar_speed) * grip * NORMAL_GRIP_MULTIPLIER * delta
  
  scalar_speed += acceleration * input.acceleration * delta
  scalar_speed -= sign(scalar_speed) * damping * delta
  if abs(scalar_speed) > max_speed:
    scalar_speed = max_speed * sign(scalar_speed)
  velocity = Vector3(0, 0, scalar_speed).rotated(Vector3(0, 1, 0), $sprite.rotation.y)

func mode_handler_slide(delta, input):
  gripping_time -= delta
  if not input.handbrake:
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
    $sprite.rotation.y += input.steering * grip * SLIDING_GRIP_MULTIPLIER * delta * slide_steering_multiplier
  
  velocity += Vector3(0, 0, acceleration * SLIDING_ACCELERATION_MULTIPLIER * input.acceleration).rotated(Vector3(0, 1, 0), $sprite.rotation.y) * delta
  velocity -= velocity.normalized() * damping * SLIDING_DAMPING_MULTIPLIER * delta

func check_collisions():
  if get_slide_collision_count() == 0 or velocity.length_squared() < 0.5:
    return
  var collision = get_last_slide_collision()
  var collider = collision.get_collider()
  if collider is Vehicle:
    handle_vehicle_collision(collider)
  else:
    handle_wall_collision(collision)

func check_slide_exit(input):
  if velocity.length_squared() < STEERING_THRESHOLD:
    if movement_mode != MovementMode.NORMAL:
      movement_mode = MovementMode.NORMAL
      scalar_speed = 0
    if input.acceleration == 0:
      scalar_speed = 0
  elif velocity.length_squared() > max_speed * max_speed:
    velocity = velocity.normalized() * max_speed

func handle_wall_collision(collision):
  velocity = velocity_last_frame.bounce(collision.get_normal()) * FORCE_HIT_MULTIPLIER
  movement_mode = MovementMode.SLIDING
  gripping_time = GRIPPING_TIME_AFTER_HIT
  slide_steering_multiplier = 1

func handle_vehicle_collision(vehicle):
  if RegisteredCollisions.registered_vehicle_collisions.has(str(vehicle.get_path()) + str(get_path())):
    return
  set_velocity_after_vehicle_hit(self, vehicle)
  set_velocity_after_vehicle_hit(vehicle, self)
  RegisteredCollisions.registered_vehicle_collisions.append(str(get_path()) + str(vehicle.get_path()))

func set_velocity_after_vehicle_hit(me, them):
  var normal = (me.global_position - them.global_position).normalized()
  me.velocity = me.velocity_last_frame * COLLISION_VELOCITY_MULTIPLIER + normal * (me.velocity_last_frame.length() + them.velocity_last_frame.length() + VEHICLE_COLLISION_BASE_FORCE) * 0.3
  me.movement_mode = MovementMode.SLIDING
  me.gripping_time = GRIPPING_TIME_AFTER_HIT
  me.slide_steering_multiplier = 1

func process_smoke():
  for child in %tyres.get_children():
    child.get_node('smoke').emitting = movement_mode == MovementMode.SLIDING

func _ready():
  process_smoke.call_deferred()
  init_control(control_type, control_metadata)
  
  if texture != null:
    $sprite.texture = texture
  
  collect_checkpoint(false)
  
  Race.players.append(self)

func handle_power_ups(input):
  if input.power_up:
    match power_up:
      'boost':
        $power_ups/boost.activate()
      'rocket':
        $power_ups/rocket_spawner.activate()
    power_up = null

var states_lookup = {
  MovementMode.NORMAL: mode_handler_normal,
  MovementMode.SLIDING: mode_handler_slide,
}

func _physics_process(delta):
  if not Race.race_started:
    return
  var input = input_manager.get_input()
  
  states_lookup[movement_mode].call(delta, input)
  handle_power_ups(input)
  check_collisions()
  check_slide_exit(input)
  
  velocity_last_frame = velocity
  move_and_slide()
  process_smoke()
