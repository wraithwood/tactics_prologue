extends Node2D

@onready var astar = AStar2D.new()
@onready var grass_layer: TileMapLayer = $"/root/Main/TileLayers/Grass"
@onready var pathfinding_layer: TileMapLayer = $"/root/Main/TileLayers/Pathfinding"
const TILE_SIZE: Vector2 = Vector2(16, 16)
const NEIGHBORS_SCAFFOLDING: Array = [
	Vector2i(1, 0),  # Right
	Vector2i(-1, 0), # Left
	Vector2i(0, 1),  # Down
	Vector2i(0, -1)  # Up
]

var registered_characters: Dictionary = {}

func _ready():
	 # Initialize the pathfinding grid based on the grass tilemap dimensions
	var used_cells = grass_layer.get_used_cells()
	
	# Add points to AStar2D grid
	for cell in used_cells:
		var cell_id = _calculate_point_index(cell)
		
		# Add the point if it's walkable (you can define your own logic here)
		if is_cell_walkable(cell):
			astar.add_point(cell_id, cell)
			
			# Connect to neighboring cells
			_connect_neighbors(cell)


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
	var cell_id = _calculate_point_index(cell)
	
	for neighbor in NEIGHBORS_SCAFFOLDING:
		var next_cell = cell + neighbor
		if is_cell_walkable(next_cell):
			var neighbor_id = _calculate_point_index(next_cell)
			if astar.has_point(neighbor_id) and astar.has_point(cell_id) and not astar.are_points_connected(cell_id, neighbor_id):
				astar.connect_points(cell_id, neighbor_id)
				

func find_path(from: Vector2i, to: Vector2i) -> PackedVector2Array:
	var start_id = _calculate_point_index(from)
	var end_id = _calculate_point_index(to)
	return astar.get_point_path(start_id, end_id)
	

func plan_movement_draw_cells(current_position: Vector2i, distance_allowed: int) -> Array:
	var reachable_positions = []
	var visited = {}  # Dictionary to track visited tiles (key: position, value: distance)
	
	# Directions for orthogonal movement: Up, Down, Left, Right
	var directions = [
		Vector2i(0, 1),  # Up
		Vector2i(0, -1), # Down
		Vector2i(1, 0),  # Right
		Vector2i(-1, 0)  # Left
	]
	
	# Starting point
	visited[current_position] = 0  # Mark current position as visited with distance 0
	
	# Queue for BFS: stores tuples of (position, distance)
	var queue = [[current_position, 0]]  # Starting position with 0 distance
	
	# Perform BFS to explore all reachable positions up to distance 2
	while queue:
		var first_item = queue.pop_front()
		var current = first_item[0]
		var dist = first_item[1]
		
		# If distance is less than 2, expand to neighbors
		if dist < distance_allowed:
			for direction in directions:
				var next_position = current + direction
				if not visited.has(next_position):  # If this tile hasn't been visited
					visited[next_position] = dist + 1  # Mark as visited with the new distance
					queue.append([next_position, dist + 1])  # Add to the queue for further exploration
					
	# Now, gather all positions that are within distance 2
	for position in visited.keys():
		if visited[position] <= distance_allowed:  # Only include tiles within the 2-step range
			reachable_positions.append(position)
			
	return reachable_positions
	
	
func register_character(character: Sprite2D, starting_position: Vector2i) -> bool:
	PathfindingManager.registered_characters[character.UNIQUE_NAME] = {
		"current_position": starting_position,
		"object": character
	}
	
	return true
	
	
