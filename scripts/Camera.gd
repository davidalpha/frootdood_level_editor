extends Camera

const MOUSE_SENSITIVITY = 0.002



# The camera movement speed (tweakable using the mouse wheel)
var move_speed := 0.5

# Stores where the camera is wanting to go (based on pressed keys and speed modifier)
var motion := Vector3()

# Stores the effective camera velocity
var velocity := Vector3()

# The initial camera node rotation
var initial_rotation := rotation.y


func _input(event: InputEvent) -> void:
	# Mouse look (effective only if the mouse is captured)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Horizontal mouse look
		rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		# Vertical mouse look, clamped to -90..90 degrees
		rotation.x = clamp(rotation.x - event.relative.y * MOUSE_SENSITIVITY, deg2rad(-90), deg2rad(90))





func _process(delta: float) -> void:
	if Input.is_action_pressed("move_forward"):
		motion.z = -1
	elif Input.is_action_pressed("move_backward"):
		motion.z = 1
	else:
		motion.z = 0

	if Input.is_action_pressed("move_left"):
		motion.x = -1
	elif Input.is_action_pressed("move_right"):
		motion.x = 1
	else:
		motion.x = 0

	if Input.is_action_pressed("move_up"):
		motion.y = 1
	elif Input.is_action_pressed("move_down"):
		motion.y = -1
	else:
		motion.y = 0

	# Normalize motion
	# (prevents diagonal movement from being `sqrt(2)` times faster than straight movement)
	motion = motion.normalized()

	# Speed modifier
	if Input.is_action_pressed("move_speed"):
		motion *= 3
		
	# toggle cursor from visible to captured
	if Input.is_action_just_released("toggle_cursor"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else	:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	# Rotate the motion based on the camera angle
	motion = motion \
		.rotated(Vector3(0, 1, 0), rotation.y - initial_rotation) \
		.rotated(Vector3(1, 0, 0), cos(rotation.y) * rotation.x) \
		.rotated(Vector3(0, 0, 1), -sin(rotation.y) * rotation.x)

	# Add motion, apply friction and velocity
	velocity += motion * move_speed
	velocity *= 0.9
	translation += velocity * delta


func _exit_tree() -> void:
	# Restore the mouse cursor upon quitting
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
