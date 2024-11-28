extends CharacterBody3D

@onready var agent = $NavigationAgent3D
var SPEED = 2
var target: Vector3
var targetCharacter
var roam = false
var coolDown = 3.0
var canAttack = true
var damage = 1
@export_enum("Enemy1","Enemy2","Enemy3") var EnemyVariant: int
@export var totalHealth = 20
var health = totalHealth
var key = "res://key.tscn"
var finalDogs = load("res://final_dogs.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	if roam:
		rng.randomize()
		target = Vector3(randf_range(-45,45),0,randf_range(-45,45))
		updateTargetLocation(target)
	else:
		target = position
		
	$Enemy1.visible = false
	$Enemy2.visible = false
	$Enemy3.visible = false
			
	match EnemyVariant:
		0:
			$Enemy1.visible = true
		1:
			$Enemy2.visible = true
			damage = 2
		2:
			$Enemy3.visible = true
			
	await get_tree().create_timer(6.0).timeout
	summon_dogs()

func _physics_process(delta):
	if targetCharacter:
		look_at(targetCharacter.position)# + Vector3.FORWARD)
	elif position != target:
		look_at(target)
	rotation.x = 0
	rotation.z = 0
	
	var collide
	
	if targetCharacter:
		updateTargetLocation(targetCharacter.position)
	
	if position.distance_to(agent.get_next_path_position()) > 0.5 and $AudioStreamPlayer4.playing == false:
		var current_location = global_transform.origin
		var next_location = agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		target.y = position.y
		velocity = new_velocity
		velocity.y = 0
		collide = move_and_collide(velocity * delta)
	elif roam:
		rng.randomize()
		target = Vector3(randf_range(-45,45),0,randf_range(-45,45))
		updateTargetLocation(target)
		
	if collide:
		var collider = collide.get_collider()
		if collider.is_in_group("Player") and canAttack and $CollisionShape3D.disabled != true:
			canAttack = false
			$AudioStreamPlayer2.play()
			collider.takeDamage(damage)
			await get_tree().create_timer(coolDown).timeout
			canAttack = true
			
	if !canAttack:
		pass
		#targetCharacter = null
		#updateTargetLocation(target)
	
func updateTargetLocation(targetVar):
	agent.set_target_position(targetVar)


func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		if EnemyVariant == 1:
			$AudioStreamPlayer3.play()
		else:
			$AudioStreamPlayer.play()
		targetCharacter = body
		updateTargetLocation(targetCharacter.position)

func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		canAttack = true
		targetCharacter = null
		updateTargetLocation(target)

func take_damage():
	health -= 1
	var healthPercentage = float(health)/totalHealth
	$Control/enemyForeground.size.x = $Control/enemyBackground.size.x * (healthPercentage)
	if health <= 0 and $CollisionShape3D.disabled != true:
		die()
		
func die():
	$CollisionShape3D.disabled = true
	$AudioStreamPlayer4.play()
	while scale.x > 0:
		scale = scale - Vector3(0.01,0.01,0.01)
		await get_tree().create_timer(0.005).timeout
	await $AudioStreamPlayer4.finished
	BackgroundMusic.stop()
	var keyInst = load(key).instantiate()
	keyInst.position = position
	get_tree().root.add_child(keyInst)
	queue_free()

func summon_dogs():
	var playerInst
	if get_tree().get_nodes_in_group("Player") != []:
		playerInst = get_tree().get_nodes_in_group("Player")[0]
	var dogSpawn = get_tree().root.get_node("Level 4/DogSpawn")
	var dogBoundsMin = Vector3(dogSpawn.position.x - dogSpawn.size.x/2,0,dogSpawn.position.z - dogSpawn.size.z/2)
	var dogBoundsMax = Vector3(dogSpawn.position.x + dogSpawn.size.x/2,0,dogSpawn.position.z + dogSpawn.size.z/2)
	print("SUMMONING DOGS")
	for i in range(5):
		rng.randomize()
		var dogInst = finalDogs.instantiate()
		get_tree().get_current_scene().add_child(dogInst)
		dogInst.position.x = randf_range(dogBoundsMin.x,dogBoundsMax.x)
		dogInst.position.y = 0#-1.285
		dogInst.position.z = randf_range(dogBoundsMin.z,dogBoundsMax.z)
		if get_tree().get_nodes_in_group("NPC").size() >= i + 1:
			dogInst.targetCharacter = get_tree().get_nodes_in_group("NPC")[i]
		elif playerInst:
			dogInst.targetCharacter = playerInst
		else:
			dogInst.targetCharacter = null
		#dogInst.jump()
	await get_tree().create_timer(6.0).timeout
	summon_dogs()
