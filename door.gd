extends StaticBody3D

var openVar = false

func _on_detection_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if body.keyCount > 0:
			if $AudioStreamPlayer:
				$AudioStreamPlayer.play()
				await $AudioStreamPlayer.finished
			openVar = true
			body.keyCount -= 1
			

func _process(delta):
	if openVar:
		position.y = move_toward(position.y, 2.688, delta * 3)
		if position.y == 500:
			queue_free()
