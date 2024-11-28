extends CharacterBody3D

@onready var agent = $NavigationAgent3D
var SPEED = 3.5
var target: Vector3
var targetCharacter
var roam = false
var coolDown = 3.0
var canAttack = true
@export_enum("BrownDog","WhiteDog") var EnemyVariant: int
var damage = 1
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var rng = RandomNumberGenerator.new()

func _ready():
	if roam:
		rng.randomize()
		target = Vector3(randf_range(-45,45),0,randf_range(-45,45))
		updateTargetLocation(target)
	else:
		target = position
		
	rng.randomize()
	EnemyVariant = randi_range(0,1)
		
	$BrownDog.visible = false
	$WhiteDog.visible = false
	
	match EnemyVariant:
		0:
			$BrownDog.visible = true
		1:
			$WhiteDog.visible = true
			
	await get_tree().create_timer(24.0).timeout
	queue_free()

func _physics_process(delta):
	if velocity.y > 0:
		velocity.y -= gravity * delta * 10
	
	if targetCharacter and is_instance_valid(targetCharacter):
		look_at(targetCharacter.position)# + Vector3.FORWARD)
	elif !global_transform.origin.is_equal_approx(target):
		look_at(target)
	rotation.x = 0
	rotation.z = 0
	
	var collide
	
	if targetCharacter and is_instance_valid(targetCharacter):
		updateTargetLocation(targetCharacter.position)
	
	if position.distance_to(agent.get_next_path_position()) > 0.5:
		var current_location = global_transform.origin
		var next_location = agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		#new_velocity.y = velocity.y
		#target.y = position.y
		velocity = new_velocity
		collide = move_and_collide(velocity * delta)
		#velocity.y = 0
	elif roam:
		rng.randomize()
		target = Vector3(randf_range(-45,45),0,randf_range(-45,45))
		updateTargetLocation(target)
		
		
	if collide:
		var collider = collide.get_collider()
		if collider.is_in_group("Player") and canAttack:
			canAttack = false
			$AudioStreamPlayer2.play()
			collider.takeDamage(damage)
			await get_tree().create_timer(coolDown).timeout
			canAttack = true
		elif collider.is_in_group("NPC"):
			collider.queue_free()
			queue_free()
			
	if !canAttack:
		targetCharacter = null
		updateTargetLocation(target)
	
func updateTargetLocation(targetVar):
	agent.set_target_position(targetVar)


func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		$AudioStreamPlayer.play()
		targetCharacter = body
		updateTargetLocation(targetCharacter.position)

func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		canAttack = true
		targetCharacter = null
		updateTargetLocation(target)
		
func jump():
	velocity.y = 20
