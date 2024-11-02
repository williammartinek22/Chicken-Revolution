extends Node3D

const SCROLL_SPEED = 10
var perspectiveMovement = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	perspectiveMovement = $Control/CheckBox.button_pressed
	
	if Input.is_key_pressed(KEY_W):
		if (perspectiveMovement):
			translate(Vector3(SCROLL_SPEED * delta,0,-SCROLL_SPEED * delta))
		else:
			translate(Vector3(SCROLL_SPEED * delta,0,0))
	
	if Input.is_key_pressed(KEY_S):
		if (perspectiveMovement):
			translate(Vector3(-SCROLL_SPEED * delta,0,SCROLL_SPEED * delta))
		else:
			translate(Vector3(-SCROLL_SPEED * delta,0,0))
		
	if Input.is_key_pressed(KEY_A):
		if (perspectiveMovement):
			translate(Vector3(-SCROLL_SPEED*delta,0,-SCROLL_SPEED*delta))
		else:
			translate(Vector3(0,0,-SCROLL_SPEED * delta))
		
	if Input.is_key_pressed(KEY_D):
		if (perspectiveMovement):
			translate(Vector3(SCROLL_SPEED*delta,0,SCROLL_SPEED*delta))
		else:
			translate(Vector3(0,0,SCROLL_SPEED * delta))
			
	if Input.is_key_pressed(KEY_CTRL):
		translate(Vector3(0,-SCROLL_SPEED * delta,0))
		
	if Input.is_key_pressed(KEY_SHIFT):
		translate(Vector3(0,SCROLL_SPEED * delta,0))
