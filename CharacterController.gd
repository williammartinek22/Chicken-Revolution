extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = default_gravity
@export var perspectiveMovement = true
@export var jumpBufferVal = 0.4
@export var eggProjectile = load("res://egg_projectile.tscn")
var canJump = true
var jumpBuffer = false
var landing = false
var lastDirection = Vector3.FORWARD
var canShoot = true


func _ready():
	pass

func _physics_process(delta):
	#if get_tree().paused:
		#return
		
	# pull player to the ground, use jump buffer, and trigger dust effect on landing
	if not is_on_floor():
		velocity.y -= gravity * delta
		landing = true
		if canJump and !jumpBuffer:
			jumpBuffer = true
			await get_tree().create_timer(jumpBufferVal).timeout
			jumpBuffer = false
			canJump = false
	else:
		if landing:
			$GPUParticles3D.restart()
			landing = false
		canJump = true
		jumpBuffer = false
		
	# Handle jump.
	if Input.is_action_pressed("ui_accept") and canJump:
		canJump = false
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("ui_accept") and !is_on_floor() and velocity.y < 0:
		if !$AudioStreamPlayer2.playing:
			$AudioStreamPlayer2.play()
		gravity = default_gravity / 5
	else:
		gravity = default_gravity

	# Handle player input
	var input_dir = Vector3.ZERO
	
	if Input.is_action_pressed("ui_up"):
		if (perspectiveMovement):
			input_dir += (Vector3(SPEED * delta, 0, -SPEED * delta))
		else:
			input_dir += (Vector3(SPEED * delta, 0, 0))
	
	if Input.is_action_pressed("ui_down"):
		if (perspectiveMovement):
			input_dir += (Vector3(-SPEED * delta, 0, SPEED * delta))
		else:
			input_dir += (Vector3(-SPEED * delta, 0, 0))
		
	if Input.is_action_pressed("ui_left"):
		if (perspectiveMovement):
			input_dir += (Vector3(-SPEED * delta, 0, -SPEED * delta))
		else:
			input_dir += (Vector3(0, 0, -SPEED * delta))
		
	if Input.is_action_pressed("ui_right"):
		if (perspectiveMovement):
			input_dir += (Vector3(SPEED * delta, 0, SPEED * delta))
		else:
			input_dir += (Vector3(0, 0, SPEED * delta))
		
	if Input.is_action_just_released("shoot") and canShoot:
		shoot()
			
	var direction = (transform.basis * input_dir).normalized()
	if direction != Vector3.ZERO:
		lastDirection = direction
	if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	# Look in the direction it is moving
	if has_node("PlayerOrigin"):
		$PlayerOrigin.rotation.y = lerp_angle($PlayerOrigin.rotation.y, atan2(-lastDirection.x, -lastDirection.z), delta * 20)

func obtain_egg():
	print("Egg obtained!")

func _notification(item):
	if item == NOTIFICATION_PREDELETE and get_tree():
		$Camera3D.reparent(get_tree().root)
		
func shoot():
	var egg_inst = eggProjectile.instantiate()
	get_tree().root.add_child(egg_inst)
	egg_inst.position = position
	egg_inst.rotation.y =  $PlayerOrigin.rotation.y
	$AudioStreamPlayer.play()
	canShoot = false
	await get_tree().create_timer(0.5).timeout
	canShoot = true
