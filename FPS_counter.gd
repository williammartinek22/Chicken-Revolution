extends RichTextLabel


func _physics_process(delta: float) -> void:
	text = str(Engine.get_frames_per_second()) + " FPS"
