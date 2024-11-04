extends CanvasLayer

var is_paused = false

func _ready():
	print("PauseMenu ready - Starting setup")
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	$Control.hide()
	is_paused = false
	print("PauseMenu setup complete")

func _input(event):
	print("Input received in PauseMenu:", event)
	if event.is_action_pressed("pause"):
		print("Pause key detected")
		if !is_paused:
			pause()
		else:
			resume()
		get_viewport().set_input_as_handled()

func pause():
	print("Pausing game")
	is_paused = true
	$Control.show()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func resume():
	print("Resuming game")
	is_paused = false
	$Control.hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_button_pressed():
	resume()

func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://OptionsMenu.tscn")
	get_tree().paused = false

func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")
