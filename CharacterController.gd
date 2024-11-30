extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const EGG_COOLDOWN = 0.5

var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = default_gravity
@export var perspectiveMovement = true
@export var jumpBufferVal = 0.4
@export var eggProjectile = load("res://egg_projectile.tscn")
var finalChickens = load("res://final_chickens.tscn")

var canJump = true
var jumpBuffer = false
var landing = false
var lastDirection = Vector3.FORWARD
var canShoot = true
var keyCount = 0
var speedVal = SPEED
var eggCooldownVal = EGG_COOLDOWN
var totalHealth = 5
var health = totalHealth
@onready var healthyGreen = $HealthBar/Foreground.color
var rng

func _ready():
	if has_node("Button"):
		await get_tree().create_timer(4.0).timeout
		$Button.disabled = false
	rng = RandomNumberGenerator.new()
	GameManager.set_player(self)

func _physics_process(delta):
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
		$AnimationPlayer.play("flap")
		if !$AudioStreamPlayer2.playing:
			$AudioStreamPlayer2.play()
		gravity = default_gravity / 5
	else:
		$AnimationPlayer.play("rest",-1,4)
		gravity = default_gravity

	# Handle player input
	var input_dir = Vector3.ZERO
	
	if Input.is_action_pressed("ui_up"):
		if (perspectiveMovement):
			input_dir += (Vector3(speedVal * delta, 0, -speedVal * delta))
		else:
			input_dir += (Vector3(speedVal * delta, 0, 0))
	
	if Input.is_action_pressed("ui_down"):
		if (perspectiveMovement):
			input_dir += (Vector3(-speedVal * delta, 0, speedVal * delta))
		else:
			input_dir += (Vector3(-speedVal * delta, 0, 0))
		
	if Input.is_action_pressed("ui_left"):
		if (perspectiveMovement):
			input_dir += (Vector3(-speedVal * delta, 0, -speedVal * delta))
		else:
			input_dir += (Vector3(0, 0, -speedVal * delta))
		
	if Input.is_action_pressed("ui_right"):
		if (perspectiveMovement):
			input_dir += (Vector3(speedVal * delta, 0, speedVal * delta))
		else:
			input_dir += (Vector3(0, 0, speedVal * delta))
		
	if Input.is_action_just_released("shoot") and canShoot:
		shoot()
			
	var direction = (transform.basis * input_dir).normalized()
	if direction != Vector3.ZERO:
		lastDirection = direction
	if direction:
			velocity.x = direction.x * speedVal
			velocity.z = direction.z * speedVal
	else:
		velocity.x = move_toward(velocity.x, 0, speedVal)
		velocity.z = move_toward(velocity.z, 0, speedVal)

	move_and_slide()

	# Look in the direction it is moving
	if has_node("PlayerOrigin"):
		$PlayerOrigin.rotation.y = lerp_angle($PlayerOrigin.rotation.y, atan2(-lastDirection.x, -lastDirection.z), delta * 20)

func obtain_egg():
	print("Egg obtained!")

func obtain_key():
	keyCount += 1
	print("Key obtained!")

func obtain_power_up():
	#Todo: Make the power up do something
	speedVal = 7
	eggCooldownVal = 0.25
	print("Power up obtained!")
	await get_tree().create_timer(5.0).timeout
	speedVal = SPEED
	eggCooldownVal = EGG_COOLDOWN

func _notification(item):
	if not is_inside_tree():
		return
	if item == NOTIFICATION_PREDELETE and get_tree():
		$camera_rig/Camera3D.current = true
		$camera_rig/Camera3D.reparent(get_tree().root)
		
func shoot():
	var egg_inst = eggProjectile.instantiate()
	get_tree().root.add_child(egg_inst)
	egg_inst.position = position
	egg_inst.rotation.y =  $PlayerOrigin.rotation.y
	$AudioStreamPlayer.play()
	canShoot = false
	await get_tree().create_timer(eggCooldownVal).timeout
	canShoot = true

func takeDamage(damage):
	health -= damage
	if health > totalHealth:
		health = totalHealth
	var healthPercentage = float(health)/totalHealth
	$HealthBar/Foreground.size.x = $HealthBar/Background.size.x * (healthPercentage)
	if healthPercentage > 0.75:
		$HealthBar/Foreground.color = healthyGreen
	elif healthPercentage > 0.34:
		$HealthBar/Foreground.color = Color.YELLOW
	elif healthPercentage > 0.00:
		$HealthBar/Foreground.color = Color.RED
	else:
		queue_free()
		
		
func _on_button_button_down() -> void:
	$Button.release_focus()
	var bossInst
	if get_tree().get_nodes_in_group("Boss") != []:
		bossInst = get_tree().get_nodes_in_group("Boss")[0]
	var chickenSpawn = get_tree().root.get_node("Level 4/ChickenSpawn")
	var chickenBoundsMin = Vector3(chickenSpawn.position.x - chickenSpawn.size.x/2,0,chickenSpawn.position.z - chickenSpawn.size.z/2)
	var chickenBoundsMax = Vector3(chickenSpawn.position.x + chickenSpawn.size.x/2,0,chickenSpawn.position.z + chickenSpawn.size.z/2)
	print("SPAWN CHICKENS")
	for i in range(15):
		rng.randomize()
		var chickenInst = finalChickens.instantiate()
		get_tree().get_current_scene().add_child(chickenInst)
		chickenInst.position.x = randf_range(chickenBoundsMin.x,chickenBoundsMax.x)
		chickenInst.position.y = -1.285
		chickenInst.position.z = randf_range(chickenBoundsMin.z,chickenBoundsMax.z)
		if get_tree().get_nodes_in_group("Enemy").size() >= i + 1:
			chickenInst.targetCharacter = get_tree().get_nodes_in_group("Enemy")[i]
		elif bossInst:
			chickenInst.targetCharacter = bossInst
		else:
			chickenInst.targetCharacter = self
	$Button.disabled = true
	await get_tree().create_timer(3.0).timeout
	$Button.disabled = false
