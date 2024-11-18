extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		visible = false
		body.takeDamage(-5)
		$AudioStreamPlayer.play()
		await $AudioStreamPlayer.finished
		queue_free()