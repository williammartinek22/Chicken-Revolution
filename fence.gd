extends StaticBody3D

var layer = 0

func set_to_foreground():
	if layer != 2:
		layer = 2
		get_child(1).set_layer_mask_value(1,false)
		get_child(1).set_layer_mask_value(2,true)
	
func set_to_background():
	if layer != 1:
		layer = 1
		get_child(1).set_layer_mask_value(1,true)
		get_child(1).set_layer_mask_value(2,false)
	
func _process(delta):
	if !GameManager.player:
		return
	#if GameManager.player.global_position.x > $CollisionShape3D.global_position.x + $CollisionShape3D.shape.extents.x and GameManager.player.global_position.z < $CollisionShape3D.global_position.z + $CollisionShape3D.shape.extents.z:
	#if GameManager.player.global_position.x > rotatedPosition.x and GameManager.player.global_position.z < rotatedPosition.z:
	#if rotation.y == PI/2:
		#if GameManager.player.position.z < global_position.z:#.rotated(Vector3.UP,45).z:
			#set_to_background()
		#else:
			#set_to_foreground()
	#else:
		#if GameManager.player.position.x > global_position.x:#.rotated(Vector3.UP,45).x:
			#set_to_background()
		#else:
			#set_to_foreground()
	if rotation.y == 0:
		if GameManager.player.position.x < position.x:# and GameManager.player.position.x < global_position.x:
			set_to_background()
		else:
			set_to_foreground()
	else:
		if GameManager.player.position.z > position.z:# and GameManager.player.position.x < global_position.x:
			set_to_background()
		else:
			set_to_foreground()
