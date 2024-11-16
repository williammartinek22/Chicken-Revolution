extends CharacterBody3D

@onready var agent = $NavigationAgent3D
var SPEED = 3.5
var target: Vector3
var targetCharacter
var roam = false

var rng = RandomNumberGenerator.new()

func _ready():
	if roam:
		rng.randomize()
		target = Vector3(randf_range(-5,5),0,randf_range(-5,5))
		updateTargetLocation(target)
	else:
		target = position

func _physics_process(delta):
	if targetCharacter:
		look_at(targetCharacter.position)# + Vector3.FORWARD)
	elif target != position:
		look_at(target)
	rotation.x = 0
	rotation.z = 0
	
	var collide
	
	if targetCharacter:
		updateTargetLocation(targetCharacter.position)
	
	if position.distance_to(agent.get_next_path_position()) > 0.5:
		var current_location = global_transform.origin
		var next_location = agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		target.y = position.y
		velocity = new_velocity
		collide = move_and_collide(velocity * delta)
	elif roam:
		rng.randomize()
		target = Vector3(randf_range(-45,45),0,randf_range(-45,45))
		updateTargetLocation(target)
		
	if collide:
		var collider = collide.get_collider()
		if collider.is_in_group("Player"):
			$AudioStreamPlayer2.play()
			collider.queue_free()
	
func updateTargetLocation(targetVar):
	agent.set_target_position(targetVar)


func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		$AudioStreamPlayer.play()
		targetCharacter = body
		updateTargetLocation(targetCharacter.position)

func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		targetCharacter = null
		updateTargetLocation(target)
