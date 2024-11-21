extends Node


var player
var totalChickens = [0,0,0,0,0]

func set_player(player_node):
	player = player_node

func update_chicken_count(level, chickenCount):
	match str(level):
		"/root/HubLevel":
			if chickenCount > totalChickens[0]:
				totalChickens[0] = chickenCount
		"/root/Test":
			if chickenCount > totalChickens[1]:
				totalChickens[1] = chickenCount
		"/root/Level 2":
			if chickenCount > totalChickens[2]:
				totalChickens[2] = chickenCount
		"/root/Level 3":
			if chickenCount > totalChickens[3]:
				totalChickens[3] = chickenCount
		"/root/Level 4":
			if chickenCount > totalChickens[4]:
				totalChickens[4] = chickenCount
