extends KinematicBody2D

var staying = 1
var rx = 0
var random = RandomNumberGenerator.new()
var ball_speed
var start_pos
var trail
var paddle
var paddle_start_x
var ball_sprite
var tilemap
var bouncy = false
var score
var score_label
var speed_label
var paddle_shape
var paddle_width
var lives
var lives_label
var game_data

func reset():
	staying = true
	ball_speed = 1.25
	position = start_pos
	trail.clear_points()
	paddle.position.x = paddle_start_x

# Called when the node enters the scene tree for the first time.
func _ready():
	game_data = get_node("/root/GameData")
	start_pos = position
	trail = get_parent().get_node("Trail")
	paddle = get_parent().get_node("Paddle")
	ball_sprite = get_node("Ball")
	tilemap = get_parent().get_node("TileMap")
	score = 0
	lives = 3
	score_label = get_parent().get_node("Score")
	score_label.set_text("SCORE: " + String(score))
	speed_label = get_parent().get_node("Speed")
	lives_label = get_parent().get_node("Lives")
	lives_label.set_text("LIVES: " + String(lives))
	paddle_start_x = paddle.position.x
	paddle_shape = paddle.get_node("PaddleShape")
	paddle_width = paddle_shape.get_shape().get_extents().x*2
	reset()
	speed_label.set_text("SPEED: " + str(ball_speed))
	random.randomize()

func resetpos():
	position.x = rx

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if staying: trail.clear_points()
	var speed = 0.016/delta
	var x = 0
	var y = 0
	if staying and !paddle.collision_right and Input.is_action_pressed("ui_right"):
		x += speed*2
	elif staying and !paddle.collision_left and Input.is_action_pressed("ui_left"):
		x -= speed*2
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://main_game.tscn")
	if staying and Input.is_action_pressed("ui_up"):
		staying = 0
		rx = random.randf_range(225, 315)
	if !staying:
		var radians = rx/180*PI
		x += cos(radians)*ball_speed*speed
		y += sin(radians)*ball_speed*speed
	var mov = Vector2(x, y)
	var collision = test_move(transform, mov)
	if collision:
		collision()
	position += mov

func _on_BorderLeft_body_entered(area):
	rx = 180 - rx + 360


func _on_BorderRight_body_entered(area):
	rx = 180 - rx + 360


func _on_BorderTop_body_entered(body):
	rx = 360 - rx


func _on_BorderBottom_body_entered(body):
	lives -= 1
	if lives < 0:
		game_data.score = score
		get_tree().change_scene("res://game_over.tscn")
	lives_label.set_text("LIVES: " + String(lives))
	reset()
	ball_speed = 1


func _on_Paddle_body_entered(body):
	if !staying:
		var diff = global_position.x - paddle.position.x + paddle_width/2
		var rot = max(min(diff/paddle_width, 1.0), 0.0) * 90
		rx = rot + 225
		if ball_speed < 8: ball_speed += 0.25
		speed_label.set_text("SPEED: " + str(ball_speed))

func collision():
	var pos = tilemap.world_to_map(global_position - tilemap.global_position)
	var cell = tilemap.get_cellv(pos)
	if bouncy or (cell == 8 or cell == 10):
		if (rx > 315 or rx < 45) or (rx > 135 && rx < 225):
			rx = 180 - rx + 360
		else:
			rx = 360 - rx
		if cell == 8 or cell == 10:
			tilemap.throw_particles(pos)
			if cell == 8: tilemap.set_cellv(pos, 0)
			if cell == 10: tilemap.set_cellv(pos, 9)
			score += 1
			score_label.set_text("SCORE: " + String(score))
