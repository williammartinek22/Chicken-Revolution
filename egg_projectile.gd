extends Area3D

const SPEED = 9
var movementDirection

func _ready():
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.queue_free()
		queue_free()

func _process(delta):
	position += -basis.z * delta * SPEED
