extends TileMap

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	
	for cell in get_used_cells_by_id(6):
		set_cellv(cell, rng.randi_range(7, 10))
	
	update_dirty_quadrants()
