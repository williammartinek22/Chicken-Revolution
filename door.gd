extends StaticBody3D

var openVar = false

func _on_detection_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if body.keyCount > 0:
			openVar = true
			body.keyCount -= 1

func _process(delta):
	if openVar:
		open(delta)

func open(delta):
	while position.y < 1000:
		position.y += 1 * delta
		if position.y > 500:
			print("QUEUE_FREE()")
			queue_free()
