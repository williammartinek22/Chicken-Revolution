extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and visible:
		visible = false
		body.obtain_power_up()
		$AudioStreamPlayer.play()
		await $AudioStreamPlayer.finished
		queue_free()
