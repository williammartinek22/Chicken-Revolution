extends Control

func _ready() -> void:
	show()
	
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://HubLevel.tscn")

func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://OptionsMenu.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
