class_name PathfindingManager
extends Node2D

@onready var astar = AStar2D.new()
@onready var grass_layer: TileMapLayer = $"/root/Main/TileLayers/Grass"
@onready var pathfinding_layer: TileMapLayer = $"/root/Main/TileLayers/Pathfinding"
const TILE_SIZE = Vector2(16, 16)

func _ready():
	 # Initialize the pathfinding grid based on the grass tilemap dimensions
	var used_cells = grass_layer.get_used_cells()  # 0 is the layer index
	
	# Add points to AStar2D grid
	for cell in used_cells:
		var cell_id = _calculate_point_index(cell)
		
		# Add the point if it's walkable (you can define your own logic here)
		if is_cell_walkable(cell):
			astar.add_point(cell_id, cell)
			
			# Connect to neighboring cells
			_connect_neighbors(cell)
			
func _process(_delta: float):
	pass

func is_cell_walkable(cell: Vector2i) -> bool:
	# Check the pathfinding layer for walkability
	# You could use different tile IDs in the pathfinding layer to represent different properties
	var tile_id = pathfinding_layer.get_cell_source_id(cell)
	return tile_id != -1

func _calculate_point_index(cell: Vector2i) -> int:
	# Convert 2D grid position to unique index
	# This is a simple way - you might want to adjust based on your map size
	var size = grass_layer.get_used_rect().size
	return cell.x + (cell.y * size.x)

func _connect_neighbors(cell: Vector2i):
	var neighbors = [
		Vector2i(1, 0),  # Right
		Vector2i(-1, 0), # Left
		Vector2i(0, 1),  # Down
		Vector2i(0, -1)  # Up
	]
	
	var cell_id = _calculate_point_index(cell)
	
	for neighbor in neighbors:
		var next_cell = cell + neighbor
		if is_cell_walkable(next_cell):
			var neighbor_id = _calculate_point_index(next_cell)
			if not astar.are_points_connected(cell_id, neighbor_id):
				astar.connect_points(cell_id, neighbor_id)

func find_path(from: Vector2i, to: Vector2i) -> PackedVector2Array:
	var start_id = _calculate_point_index(from)
	var end_id = _calculate_point_index(to)
	return astar.get_point_path(start_id, end_id)
	
func tile_size() -> Vector2:
	return TILE_SIZE
	
