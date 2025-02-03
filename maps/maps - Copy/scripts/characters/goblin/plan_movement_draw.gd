extends Node2D

@onready var pathfinding_manager = $"../../PathfindingManager"
@onready var tile_map_layer = $"../../TileLayers/Pathfinding"
@onready var goblin = get_parent()
@onready var camera = $"../../Camera2D"
var move_range: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.z_index = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _draw() -> void:
	var canvas_transform = get_global_transform_with_canvas().affine_inverse()
	var tile_size = pathfinding_manager.TILE_SIZE
	var global_mouse_posit = get_viewport().get_mouse_position()
	print("Drawing Mouse Circle: ", global_mouse_posit)
	draw_circle(
			canvas_transform.basis_xform(global_mouse_posit) + canvas_transform[2],
			6,
			Color("478cbf")
		)
	
	for grid_location in move_range:
		print("Grid Location (Vector2i): ", grid_location)
		print("Map to Local (vector2): ", tile_map_layer.map_to_local(grid_location))
		
		var tile_pixel_position = tile_map_layer.map_to_local(grid_location)
		print ("Turning that same Vector2 back to Vector2i", tile_map_layer.local_to_map(tile_pixel_position))
		print(canvas_transform[2])
		print(canvas_transform)
		var screen_position = tile_pixel_position + canvas_transform[2]
		draw_circle(
			screen_position,
			6,
			Color("478cbf")
		)
		
		
func _calculate_move_range() -> Array:
	var current_position = goblin.current_position()
	var reachable_positions = []
	# BFS or simple range calculation (4-directional movement with a range of 4)
	for direction in pathfinding_manager.NEIGHBORS_SCAFFOLDING:
		for step in range(1, 2):  # Adjust the range here (4 steps in this case)
			var next_position = Vector2i(current_position) + (direction * step)
			if pathfinding_manager.is_cell_walkable(next_position):
				reachable_positions.append(next_position)
				
	return reachable_positions
	
	
func draw_move_range():
	move_range = _calculate_move_range()
	print('Vector2i coords in range: ', move_range)
	queue_redraw()
	
