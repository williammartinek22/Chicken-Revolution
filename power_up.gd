extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.obtain_power_up()
		queue_free()
