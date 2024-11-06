extends CharacterBody3D

var SPEED = 2
var targetCharacter = null
@onready var agent = $NavigationAgent3D
var baseY

func _ready():
	baseY = position.y

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		targetCharacter = body
		agent.set_target_position(targetCharacter.position)

func _physics_process(delta):
	if targetCharacter and is_instance_valid(targetCharacter):
		agent.set_target_position(targetCharacter.position)
		if position.distance_to(agent.get_next_path_position()) > 0.5:
			var current_location = global_transform.origin
			var next_location = agent.get_next_path_position()
			var new_velocity = (next_location - current_location).normalized() * SPEED
			velocity = new_velocity
			move_and_collide(velocity * delta)
			position.y = baseY
		if has_node("Node3D"):
			$Node3D.look_at(targetCharacter.position)
			$Node3D.rotation.x = 0
			$Node3D.rotation.z = 0
