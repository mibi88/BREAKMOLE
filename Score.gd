extends Label

var game_data
var score

func _ready():
	game_data = get_node("/root/GameData")
	score = game_data.score
	set_text("SCORE: " + String(score))
