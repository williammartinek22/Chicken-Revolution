extends Label3D

func _process(delta: float) -> void:
	var totalChickens = 0
	for value in GameManager.totalChickens:
		totalChickens += value
	text = "Chickens saved: " + str(totalChickens) + "/43"
