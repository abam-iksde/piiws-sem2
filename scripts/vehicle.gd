class_name Vehicle
extends CharacterBody3D

const STEERING_THRESHOLD = 0.2
const DRIFT_EXIT_THRESHOLD = deg_to_rad(15)

@export var max_speed = 20
@export var acceleration = 32
@export var grip = 1
@export var damping = 16

var scalar_speed = 0

enum MovementMode {
	NORMAL,
	SLIDING,
}

var movement_mode = MovementMode.NORMAL

func get_input():
	return {
		'acceleration': Input.get_axis("ui_down", "ui_up"),
		'steering': Input.get_axis("ui_right", "ui_left"),
		'handbrake': Input.is_action_pressed('ui_accept'),
	}

func normal(delta, input):
	if input['handbrake']:
		movement_mode = MovementMode.SLIDING
	
	if velocity.length_squared() > STEERING_THRESHOLD:
		$mesh_instance.rotation.y += input['steering'] * grip * 3 * delta
	
	scalar_speed += acceleration * input['acceleration'] * delta
	scalar_speed -= sign(scalar_speed) * damping * delta
	if abs(scalar_speed) > max_speed:
		scalar_speed = max_speed * sign(scalar_speed)
	velocity = Vector3(0, 0, scalar_speed).rotated(Vector3(0, 1, 0), $mesh_instance.rotation.y)

func slide(delta, input):
	if not input['handbrake']:
		if velocity.angle_to(Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), $mesh_instance.rotation.y)) < DRIFT_EXIT_THRESHOLD:
			scalar_speed = velocity.length()
			movement_mode = MovementMode.NORMAL
		elif velocity.angle_to(Vector3(0, 0, -1).rotated(Vector3(0, 1, 0), $mesh_instance.rotation.y)) < DRIFT_EXIT_THRESHOLD:
			scalar_speed = -velocity.length()
			movement_mode = MovementMode.NORMAL
	
	if velocity.length_squared() > STEERING_THRESHOLD:
		$mesh_instance.rotation.y += input['steering'] * grip * 5 * delta
	
	velocity += Vector3(0, 0, acceleration * input['acceleration']).rotated(Vector3(0, 1, 0), $mesh_instance.rotation.y) * delta
	velocity -= velocity.normalized() * damping * delta

func _physics_process(delta):
	var input = get_input()
	
	match movement_mode:
		MovementMode.NORMAL:
			normal(delta, input)
		MovementMode.SLIDING:
			slide(delta, input)
	
	if velocity.length_squared() < STEERING_THRESHOLD:
		velocity = Vector3()
	elif velocity.length_squared() > max_speed * max_speed:
		velocity = velocity.normalized() * max_speed
	
	move_and_slide()
