extends Node2D

@onready var pathfinding_manager = $"../../PathfindingManager"
@onready var tile_map_layer = $"../../TileLayers/Pathfinding"
@onready var goblin = get_parent()
var move_range: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.z_index = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _draw() -> void:
	var tile_size = pathfinding_manager.TILE_SIZE
	for grid_location in move_range:
		var tile_pixel_position = tile_map_layer.map_to_local(grid_location)
		print("Drawing rectangle at: ", tile_pixel_position)
		draw_rect(
			Rect2(tile_pixel_position, tile_size),
			Color(1, 0, 0, 1),
			true
		)
		
		
func _calculate_move_range() -> Array:
	var current_position = goblin.current_position()
	print('Current Start Vector2i Position: ', current_position)
	var reachable_positions = []
	# BFS or simple range calculation (4-directional movement with a range of 4)
	for direction in pathfinding_manager.NEIGHBORS_SCAFFOLDING:
		for step in range(1, 5):  # Adjust the range here (4 steps in this case)
			var next_position = Vector2i(current_position) + (direction * step)
			if pathfinding_manager.is_cell_walkable(next_position):
				reachable_positions.append(next_position)
				
	return reachable_positions
	
	
func draw_move_range():
	move_range = _calculate_move_range()
	print('Vector2i coords in range: ', move_range)
	queue_redraw()
	
