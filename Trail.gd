extends Line2D

var MAX_LENGTH = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_points()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ball = get_parent().get_node("Ball").get_node("Ball")
	var pos = ball.global_position - position
	add_point(pos)
	if get_point_count() > MAX_LENGTH:
		remove_point(0)
