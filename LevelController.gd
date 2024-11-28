extends Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func _ready():
	if get_tree().get_current_scene().name == "Level 4":
		BackgroundMusic.stream = load("res://game/Music/temporary boss music.mp3")
		BackgroundMusic.play()
