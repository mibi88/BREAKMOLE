extends Area2D

var collision_left = false
var collision_right = false

func _ready():
	pass

func _process(delta):
	var speed = 0.016/delta
	if !collision_right and Input.is_action_pressed("ui_right"):
		position.x += speed*2
	elif !collision_left and Input.is_action_pressed("ui_left"):
		position.x -= speed*2

func _on_BorderLeft_area_entered(area):
	collision_left = true


func _on_BorderRight_area_entered(area):
	collision_right = true


func _on_BorderLeft_area_exited(area):
	collision_left = false


func _on_BorderRight_area_exited(area):
	collision_right = false
