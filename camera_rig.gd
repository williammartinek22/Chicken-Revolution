extends Node3D

@onready var background_viewport: SubViewport = $base_camera/background_viewport_container/background_viewport
@onready var foreground_viewport: SubViewport = $base_camera/foreground_viewport_container/foreground_viewport

@onready var background_camera: Camera3D = $base_camera/background_viewport_container/background_viewport/background_camera
@onready var foreground_camera: Camera3D = $base_camera/foreground_viewport_container/foreground_viewport/foreground_camera

func resize():
	background_viewport.size = DisplayServer.window_get_size()
	foreground_viewport.size = DisplayServer.window_get_size()
	
func _ready():
	resize()
	
func _process(_delta):
	background_camera.global_transform = get_child(1).global_transform
	foreground_camera.global_transform = get_child(1).global_transform
