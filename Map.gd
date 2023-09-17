extends TileMap

var random
var PARTICLES = preload("res://particles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	random = RandomNumberGenerator.new()

func throw_particles(pos):
	var particles = PARTICLES.instance()
	get_parent().add_child(particles)
	particles.position = global_position + (pos*16)
	particles.position.x += 8
	particles.position.y += 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for pos in get_used_cells():
		var type = get_cellv(pos)
		if type == 0:
			if !random.randi_range(0, 1000):
				set_cellv(pos, 8)
				throw_particles(pos)
		elif type == 9:
			if !random.randi_range(0, 1000):
				set_cellv(pos, 10)
				throw_particles(pos)
		elif type == 8:
			if !random.randi_range(0, 500):
				set_cellv(pos, 0)
				throw_particles(pos)
		elif type == 10:
			if !random.randi_range(0, 500):
				set_cellv(pos, 9)
				throw_particles(pos)
