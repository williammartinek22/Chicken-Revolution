extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackgroundMusic.stream = load("res://game/Music/credits.mp3")
	BackgroundMusic.play()
	
	await get_tree().create_timer(5.0).timeout
	$AnimationPlayer.play("CreditScroll")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
