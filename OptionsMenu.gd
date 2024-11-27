extends Control

@onready var controls_container = $TabContainer/Controls/ScrollContainer/ControlsContainer
@onready var master_slider = $TabContainer/Audio/VBoxContainer/MasterVolume/MasterSlider
@onready var music_slider = $TabContainer/Audio/VBoxContainer/MusicVolume/MusicSlider
@onready var sfx_slider = $TabContainer/Audio/VBoxContainer/SFXVolume/SFXSlider

var action_buttons = {}
var is_remapping = false
var action_to_remap = null

const CONFIG_FILE = "user://settings.cfg"
var config = ConfigFile.new()

var currentScene = null

func _ready():
	setup_keybinds()
	load_settings()
	setup_audio_sliders()

func setup_keybinds():
	var actions = ["ui_up", "ui_down", "ui_left", "ui_right", "ui_accept"]
	var display_names = {
		"ui_up": "Move Forward",
		"ui_down": "Move Backward",
		"ui_left": "Move Left",
		"ui_right": "Move Right",
		"ui_accept": "Jump"
	}
	
	# Set default keys if not already configured
	var default_keys = {
		"ui_up": KEY_W,
		"ui_down": KEY_S,
		"ui_left": KEY_A,
		"ui_right": KEY_D,
		"ui_accept": KEY_SPACE
	}
	
	for action in actions:
		var hbox = HBoxContainer.new()
		var label = Label.new()
		var button = Button.new()
		
		label.text = display_names[action]
		label.custom_minimum_size.x = 200
		
		var events = InputMap.action_get_events(action)
		print(events)
		if events.size() > 0:
			button.text = events[0].as_text()
		else:
			# If no key is configured, use the default key
			var event = InputEventKey.new()
			event.keycode = default_keys[action]
			event.physical_keycode = default_keys[action]
			InputMap.action_add_event(action, event)
			button.text = event.as_text()
		
		button.custom_minimum_size.x = 200
		
		hbox.add_child(label)
		hbox.add_child(button)
		controls_container.add_child(hbox)
		
		button.pressed.connect(_on_keybind_button_pressed.bind(action, button))
		action_buttons[action] = button

func _on_keybind_button_pressed(action: String, button: Button):
	is_remapping = true
	action_to_remap = action
	button.text = "Press any key..."

func _input(event):
	if is_remapping and event is InputEventKey:
		if event.pressed: # Only react to key press, not release
			var current_events = InputMap.action_get_events(action_to_remap)
			
			# Check if the key is already used for this action
			if current_events.size() > 0 and current_events[0].keycode == event.keycode:
				action_buttons[action_to_remap].text = event.as_text()
			else:
				# Check if the key is already used by another action
				var is_key_used = false
				for action in action_buttons.keys():
					if action != action_to_remap:
						var events = InputMap.action_get_events(action)
						if events.size() > 0 and events[0].keycode == event.keycode:
							is_key_used = true
							break
				
				if not is_key_used:
					InputMap.action_erase_events(action_to_remap)
					InputMap.action_add_event(action_to_remap, event)
					action_buttons[action_to_remap].text = event.as_text()
					save_settings()
				else:
					# If the key is already used, restore the old configuration
					if current_events.size() > 0:
						action_buttons[action_to_remap].text = current_events[0].as_text()
			
			is_remapping = false
			action_to_remap = null

func setup_audio_sliders():
	master_slider.value_changed.connect(_on_master_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)

func _on_master_volume_changed(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	save_settings()

func _on_music_volume_changed(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	save_settings()

func _on_sfx_volume_changed(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	save_settings()

func save_settings():
	# Save keybinds
	for action in action_buttons.keys():
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			config.set_value("controls", action, events[0])
	
	# Save audio settings
	config.set_value("audio", "Master", master_slider.value)
	config.set_value("audio", "Music", music_slider.value)
	config.set_value("audio", "SFX", sfx_slider.value)
	
	config.save(CONFIG_FILE)

func load_settings():
	var err = config.load(CONFIG_FILE)
	if err != OK:
		return
		
	# Load keybinds
	for action in action_buttons.keys():
		if config.has_section_key("controls", action):
			var event = config.get_value("controls", action)
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
			action_buttons[action].text = event.as_text()
	
	# Load audio settings
	if config.has_section_key("audio", "Master"):
		master_slider.value = config.get_value("audio", "Master")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_slider.value))
	if config.has_section_key("audio", "Music"):
		music_slider.value = config.get_value("audio", "Music")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_slider.value))
	if config.has_section_key("audio", "SFX"):
		sfx_slider.value = config.get_value("audio", "SFX")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_slider.value))
	save_settings()

func _on_back_button_pressed():
	#get_tree().paused = false
	queue_free()
	#get_tree().change_scene_to_file(currentScene)
