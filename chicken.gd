extends CharacterBody3D

var SPEED = 2
var targetCharacter = null
var jumping = false
var targetPosition = null
@onready var agent = $NavigationAgent3D
var baseY
signal saved

@export var clucks : Array[AudioStreamMP3]

var rng

func _ready():
	rng = RandomNumberGenerator.new()
	baseY = position.y

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		if targetCharacter == null:
			rng.randomize()
			$AudioStreamPlayer.stream = clucks.pick_random()
			$AudioStreamPlayer.play()
		targetCharacter = body
		agent.set_target_position(targetCharacter.position)

func _physics_process(delta):
	if targetCharacter and is_instance_valid(targetCharacter):
		agent.set_target_position(targetCharacter.global_position)
		if jumping == false:# and abs(position.distance_to(agent.get_next_path_position())) > scale.x * 1.2:
			var current_location = global_transform.origin
			var next_location = agent.get_next_path_position()
			var new_velocity = (next_location - current_location).normalized() * SPEED
			velocity = new_velocity
			var collisions = move_and_collide(velocity * delta)
			position.y = baseY
			
			if collisions:
				var collider = collisions.get_collider()
				if collider.is_in_group("Player"):
					saved.emit()
					$CollisionShape3D.set_deferred("disabled", true)
					visible = false
					if !$AudioStreamPlayer.playing:
						$AudioStreamPlayer.stream = clucks.pick_random()
						$AudioStreamPlayer.play()
					await $AudioStreamPlayer.finished
					queue_free()
		elif jumping == true:
			position = position.lerp(targetPosition, delta)
			if !$AudioStreamPlayer2.playing:
				rng.randomize()
				$AudioStreamPlayer2.play(randf_range(0.0,0.3))
			if position.distance_to(targetPosition) < 1:
				jumping = false
		if has_node("Node3D") and targetCharacter:
			$Node3D.look_at(targetCharacter.global_position)
			$Node3D.rotation.x = 0
			$Node3D.rotation.z = 0

func go_home(home):
	rng.randomize()
	$AudioStreamPlayer.stream = clucks.pick_random()
	$AudioStreamPlayer.play()
	targetCharacter = home
	agent.set_target_position(home.position)
	$Area3D/CollisionShape3D.set_deferred("disabled", true)
	await get_tree().create_timer(1.5).timeout
	saved.emit()
	queue_free()


func _on_navigation_agent_3d_link_reached(details: Dictionary) -> void:
	jumping = true
	targetPosition = details["link_exit_position"]
