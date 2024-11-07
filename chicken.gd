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
		agent.set_target_position(targetCharacter.global_position)
		if true:#position.distance_to(agent.get_next_path_position()) > scale.x:
			var current_location = global_transform.origin
			var next_location = agent.get_next_path_position()
			var new_velocity = (next_location - current_location).normalized() * SPEED
			velocity = new_velocity
			move_and_collide(velocity * delta)
			position.y = baseY
		if has_node("Node3D"):
			$Node3D.look_at(targetCharacter.global_position)
			$Node3D.rotation.x = 0
			$Node3D.rotation.z = 0

func go_home(home):
	targetCharacter = home
	agent.set_target_position(home.position)
	$Area3D/CollisionShape3D.set_deferred("disabled", true)
	await get_tree().create_timer(1.5).timeout
	queue_free()
