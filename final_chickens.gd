extends CharacterBody3D

var SPEED = 3
var targetCharacter = null
var jumping = false
var targetPosition = null
@onready var agent = $NavigationAgent3D
var baseY

@export var clucks : Array[AudioStreamMP3]

var rng

func _ready():
	rng = RandomNumberGenerator.new()
	baseY = position.y
	
	

func _physics_process(delta):
	if !$AudioStreamPlayer2.playing:
		$AudioStreamPlayer2.pitch_scale = randf_range(0.75,1.25)
		$AudioStreamPlayer2.play()
	
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
				if collider.is_in_group("Boss"):
					collider.take_damage()
					queue_free()
				if collider.is_in_group("Enemy"):
					collider.queue_free()
					queue_free()
					
		elif jumping == true:
			position = position.lerp(targetPosition, delta)
			if !$AudioStreamPlayer2.playing:
				rng.randomize()
				$AudioStreamPlayer2.play(randf_range(0.0,0.3))
			if position.distance_to(targetPosition) < 1:
				jumping = false
		if has_node("Node3D") and targetCharacter:
			if targetCharacter.global_position != position:
				$Node3D.look_at(targetCharacter.global_position)
				$Node3D.rotation.x = 0
				$Node3D.rotation.z = 0
			
	if !targetCharacter and get_tree().get_nodes_in_group("Player") != []:
		targetCharacter = get_tree().get_nodes_in_group("Player")[0]


func _on_navigation_agent_3d_link_reached(details: Dictionary) -> void:
	jumping = true
	targetPosition = details["link_exit_position"]
