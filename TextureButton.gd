extends TextureButton

func _ready():
	print("restart")


func _on_TextureButton_pressed():
	get_tree().change_scene("res://main_game.tscn")
