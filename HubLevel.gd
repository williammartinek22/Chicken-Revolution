extends Node3D

var chickens_collected = 0

func _ready():
	$Enclosure.body_entered.connect(_on_enclosure_body_entered)

func _on_enclosure_body_entered(body):
	if body.is_in_group("chickens"):
		body.queue_free()
		chickens_collected += 1
		update_chicken_count_display()
		
		if chickens_collected >= 10:
			show_level_buttons()

func update_chicken_count_display():
	$ChickenCountLabel.text = "Poulets récoltés : " + str(chickens_collected) + "/10"

func show_level_buttons():
	$Level1Button.visible = true
	$Level2Button.visible = true
	$Level3Button.visible = true
	$Level4Button.visible = true

func _on_level_1_button_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://test.tscn")

func _on_level_2_button_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://level_2.tscn")

func _on_level_3_button_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://level_3.tscn")

func _on_level_4_button_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://level_4.tscn")
