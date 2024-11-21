extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and visible:
		visible = false
		body.obtain_egg()
		$AudioStreamPlayer.play()
		await $AudioStreamPlayer.finished
		get_tree().change_scene_to_file("res://HubLevel.tscn")
		queue_free()
