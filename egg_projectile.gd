extends Area3D

const SPEED = 9
var movementDirection

func _ready():
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.queue_free()
		crack()
	elif body.get_parent() is StaticBody3D:
		crack()

func _process(delta):
	position += -basis.z * delta * SPEED

func crack():
	visible = false
	$CollisionShape3D.set_deferred("disabled", true)
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	queue_free()
