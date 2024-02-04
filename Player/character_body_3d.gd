extends CharacterBody3D

@onready var camera = $camOrigin2
const GRAVITY = 57
const JUMP_ACCELERATION = 2000
const SECOND_JUMP_ACCELERATION = 1810
const MAX_JUMP_SPEED = 1000
const SPEED = 15.0
const SPRINT_SPEED = 65.0
const MOUSE_SENSITIVITY = 0.03
const MAX_JUMP_COUNT = 1
var jump_left = 2


func _input(event):
	if event is InputEventMouseMotion:
		camera.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		camera.rotation.x = clamp(camera.rotation.x - deg_to_rad(event.relative.y * MOUSE_SENSITIVITY), deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta):
	
	velocity.y -= GRAVITY * delta

	# Gérer le saut
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump_left -= 1
			velocity.y = +JUMP_ACCELERATION * delta
		else:
			if jump_left >= 1:
				jump_left -= 1
				velocity.y = 0
				velocity.y = SECOND_JUMP_ACCELERATION * delta
				velocity.y = MAX_JUMP_SPEED * delta
				
	if is_on_floor():
		jump_left = 2
			
	if Input.is_action_pressed("quit"):
		get_tree().quit()

	var input_dir = get_input_direction()
	var camera_transform = camera.global_transform
	var camera_basis = camera_transform.basis
	var move_direction = camera_basis.z.normalized() * input_dir.y + camera_basis.x.normalized() * input_dir.x
	move_direction.y = 0
	move_direction = move_direction.normalized()
	
	if Input.is_action_pressed("sprint"):
		velocity.x = move_direction.x * SPRINT_SPEED
		velocity.z = move_direction.z * SPRINT_SPEED
	else:
		velocity.x = move_direction.x * SPEED
		velocity.z = move_direction.z * SPEED
				

	move_and_slide()



func get_input_direction():
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("left"):
		input_dir.x -= 1
	if Input.is_action_pressed("right"):
		input_dir.x += 1
	if Input.is_action_pressed("up"):
		input_dir.y -= 1
	if Input.is_action_pressed("down"):
		input_dir.y += 1
	return input_dir.normalized()
