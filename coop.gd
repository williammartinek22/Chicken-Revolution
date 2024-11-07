extends StaticBody3D

func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("NPC"):
		body.go_home($Marker3D)
