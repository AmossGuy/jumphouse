extends TileMap

var rng = RandomNumberGenerator.new()

func _ready():
	var placeholder := 40 + 2 * 48
	var buildings := [0 + 21 * 48, 1 + 21 * 48, 3 + 21 * 48, 4 + 21 * 48]
	
	for cell in get_used_cells():
		print(get_cellv(cell))
	
	for cell in get_used_cells_by_id(placeholder):
		set_cellv(cell, rng.randi_range(0, buildings.size()-1))
	
	update_dirty_quadrants()
