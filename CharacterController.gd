extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = default_gravity
@export var perspectiveMovement = true
var canJump = true
var jumpBuffer = false
var landing = false

func _physics_process(delta):
	# pull player to the ground, use jump buffer, and trigger dust effect on landing
	if not is_on_floor():
		velocity.y -= gravity * delta
		landing = true
		if canJump and !jumpBuffer:
			jumpBuffer = true
			await get_tree().create_timer(.4).timeout
			jumpBuffer = false
			canJump = false
	else:
		if landing:
			$GPUParticles3D.restart()
			landing = false
		canJump = true
		jumpBuffer = false
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and canJump:
		canJump = false
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("ui_accept") and !is_on_floor() and velocity.y < 0:
		gravity = default_gravity/5
	else:
		gravity = default_gravity

	var input_dir = Vector3.ZERO
	
	if Input.is_key_pressed(KEY_W):
		if (perspectiveMovement):
			input_dir += (Vector3(SPEED * delta,0,-SPEED * delta))
		else:
			input_dir += (Vector3(SPEED * delta,0,0))
	
	if Input.is_key_pressed(KEY_S):
		if (perspectiveMovement):
			input_dir += (Vector3(-SPEED * delta,0,SPEED * delta))
		else:
			input_dir += (Vector3(-SPEED * delta,0,0))
		
	if Input.is_key_pressed(KEY_A):
		if (perspectiveMovement):
			input_dir += (Vector3(-SPEED*delta,0,-SPEED*delta))
		else:
			input_dir += (Vector3(0,0,-SPEED * delta))
		
	if Input.is_key_pressed(KEY_D):
		if (perspectiveMovement):
			input_dir += (Vector3(SPEED*delta,0,SPEED*delta))
		else:
			input_dir += (Vector3(0,0,SPEED * delta))
			
			
	var direction = (transform.basis * input_dir).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
