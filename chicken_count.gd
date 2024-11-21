extends RichTextLabel

var totalChickens
var chickensSaved = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	totalChickens = get_tree().get_nodes_in_group("NPC").size()
	for chicken in get_tree().get_nodes_in_group("NPC"):
		chicken.saved.connect(chicken_saved)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	text = str(chickensSaved) + "/" + str(totalChickens) + " Chickens"

func chicken_saved():
	chickensSaved += 1
	GameManager.update_chicken_count(get_tree().current_scene.get_path(), chickensSaved)
	print(get_tree().current_scene.get_path())
	print(GameManager.totalChickens)
