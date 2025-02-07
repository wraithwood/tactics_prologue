extends Node2D

@onready var tile_map_layer = $"../../TileLayers/Pathfinding"

const PHASE_START: String = "start"
const PHASE_ATTACKING: String = "attacking"

var attack_tile_directions: Array = []
var phase: String = PHASE_START
var _selected_tile: Vector2i = Vector2i(0, 0)
var _is_selecting_tile: bool = false
var draw_for_tiles: Array = []

var actor = null

signal attack_target_at_tile(tile: Vector2i)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.z_index = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if TurnManager.turn_phase == TurnManager.PLAN_ATTACK_PHASE and phase == PHASE_START and TurnManager.is_my_turn("goblin"):
		if !_is_selecting_tile:
			_is_selecting_tile = true
			if Input.is_action_just_pressed("MoveLeft"):
				_discern_tile_to_be_selected_from_directional_input("MoveLeft")
			if Input.is_action_just_pressed("MoveRight"):
				_discern_tile_to_be_selected_from_directional_input("MoveRight")
			if Input.is_action_just_pressed("MoveUp"):
				_discern_tile_to_be_selected_from_directional_input("MoveUp")
			if Input.is_action_just_pressed("MoveDown"):
				_discern_tile_to_be_selected_from_directional_input("MoveDown")
			if Input.is_action_just_pressed("UiAccept"):
				phase = PHASE_ATTACKING
				print("ATTACKING_TILE: ", _selected_tile)
				attack_target_at_tile.emit(_selected_tile)
				
				
			queue_redraw()
			_is_selecting_tile = false


func _draw() -> void:
	if phase == "start":
		var tile_size = PathfindingManager.TILE_SIZE
	
		for tile in draw_for_tiles:
			var color
			if tile == _selected_tile:
				color = Color(1, 0, 0, 0.5)  # Red with 50% transparency
			else:
				color = Color(0, 1, 0, 0.5)  # Green with 50% transparency
				continue
			var tile_pixel_position = tile_map_layer.map_to_local(tile) + Vector2(8, 8)
			draw_rect(
				Rect2(get_screen_position(tile_pixel_position) - Vector2(6, 6), Vector2(12, 12)),
				color
			)
	
	
func draw_attackable_range(tile_directions: Array, current_position: Vector2i) -> void:
	queue_redraw()
	
func get_selected_tile():
	return _selected_tile
	
	
func set_selected_tile(selected_tile: Vector2i) -> void:
	_selected_tile = selected_tile

	
func _discern_tile_to_be_selected_from_directional_input(input: String):
	if input == "MoveLeft":
		var new_selected_tile = Vector2i(_selected_tile.x - 1, _selected_tile.y)
		if draw_for_tiles.has(new_selected_tile):
			_selected_tile = new_selected_tile
		else:
			var max_x = -INF
			for tile in draw_for_tiles:
				if tile.y == new_selected_tile.y:
					max_x = max(max_x, tile.x)
			_selected_tile = Vector2i(max_x, new_selected_tile.y)
			
	if input == "MoveRight":
		var new_selected_tile = Vector2i(_selected_tile.x + 1, _selected_tile.y)
		if draw_for_tiles.has(new_selected_tile):
			_selected_tile = new_selected_tile
		else:
			var min_x = INF
			for tile in draw_for_tiles:
				if tile.y == new_selected_tile.y:
					min_x = min(min_x, tile.x)
			_selected_tile = Vector2i(min_x, new_selected_tile.y)
			
	if input == "MoveUp":
		var new_selected_tile = Vector2i(_selected_tile.x, _selected_tile.y - 1)
		if draw_for_tiles.has(new_selected_tile):
			_selected_tile = new_selected_tile
		else:
			var max_y = -INF
			for tile in draw_for_tiles:
				if tile.x == new_selected_tile.x:
					max_y = max(max_y, tile.y)
			_selected_tile = Vector2i(new_selected_tile.x, max_y)
			
	if input == "MoveDown":
		var new_selected_tile = Vector2i(_selected_tile.x, _selected_tile.y + 1)
		if draw_for_tiles.has(new_selected_tile):
			_selected_tile = new_selected_tile
		else:
			var min_y = INF
			for tile in draw_for_tiles:
				if tile.x == new_selected_tile.x:
					min_y = min(min_y, tile.y)
			_selected_tile = Vector2i(new_selected_tile.x, min_y)
		
		
func get_screen_position(event_position: Vector2):
	var canvas_transform = get_global_transform_with_canvas().affine_inverse()
	return event_position + canvas_transform[2]
	

func possible_targets(tile_directions: Array, current_position: Vector2i) -> Array:
	var can_attack_tiles = _get_attackable_tiles(tile_directions, current_position)
	var targets = []
	var character_names = PathfindingManager.registered_characters.keys()
	for name in character_names:
		if name == actor.UNIQUE_NAME:
			continue
		var actor_position = PathfindingManager.registered_characters[name]["current_position"]
		if can_attack_tiles.has(actor_position):
			targets.push(actor_position)
	
	return targets
		

func _get_attackable_tiles(tile_directions: Array, current_position: Vector2i) -> Array:
	var tiles = []
	for tile_direction in tile_directions:
		var attackable_tile = current_position + Vector2i(tile_direction)
		tiles.push(attackable_tile)
		
	return tiles
