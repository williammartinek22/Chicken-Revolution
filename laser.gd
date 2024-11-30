extends RayCast3D

@onready var beam_mesh: MeshInstance3D = $BeamMesh
@onready var end_particles: GPUParticles3D = $EndParticles

var noHit = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		$AudioStreamPlayer.play()
	
	
	var player
	if get_tree().get_nodes_in_group("Player") != []:
		player = get_tree().get_nodes_in_group("Player")[0]
		#target_position = player.global_position
		#force_raycast_update()
		#look_at(player.global_position)
	
	var cast_point
	force_raycast_update()
	
	if is_colliding():
		pass
	
	if true:
		cast_point = to_local(get_collision_point())
		
		beam_mesh.mesh.height = cast_point.y
		beam_mesh.position.y = cast_point.y/2
	
	if get_collider() == player and !noHit:
		noHit = true
		player.takeDamage(1)
