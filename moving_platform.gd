extends Node3D

var forward = true
var speed = 2

func _process(delta):
	if forward:
		$RemoteTransform3D.position = $RemoteTransform3D.position.move_toward($End.position,delta * speed)
		if $RemoteTransform3D.position == $End.position:
			forward = false
	else:
		$RemoteTransform3D.position = $RemoteTransform3D.position.move_toward($Start.position,delta * speed)
		if $RemoteTransform3D.position == $Start.position:
			forward = true
