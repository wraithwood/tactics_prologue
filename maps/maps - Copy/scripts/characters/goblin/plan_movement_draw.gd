# This script handles all the plan movement phase for all player characters. It will be
# reworked to register an instance for character.
# It will plug into the pathfinding manager and the turn manager that will act as sources of
# truth for game lifecycle state as well as tile map state.

extends Node2D

@onready var tile_map_layer = $"../../TileLayers/Pathfinding"
@onready var goblin = get_parent()
@onready var camera = $"../../Camera2D"

const PHASE_START: String = "start"
const PHASE_MOVING: String = "moving"

var move_range: Array = []
var phase: String = PHASE_START
var _selected_tile: Vector2i = Vector2i(0, 0)
var _is_selecting_tile: bool = false

signal move_to_tile(tile: Vector2i)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.z_index = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if TurnManager.turn_phase == TurnManager.PLAN_MOVE_PHASE and phase == PHASE_START and TurnManager.is_my_turn("goblin"):
		if _selected_tile == Vector2i(0, 0):
			_selected_tile = move_range[1]
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
				phase = PHASE_MOVING
				print("SELECTED_TILE: ", _selected_tile)
				move_to_tile.emit(_selected_tile)
				
				
			queue_redraw()
			_is_selecting_tile = false


func _draw() -> void:
	if phase == "start":
		var tile_size = PathfindingManager.TILE_SIZE
	
		for grid_location in move_range:
			var color
			if grid_location == _selected_tile:
				color = Color(1, 0, 0, 0.5)  # Red with 50% transparency
			else:
				color = Color(0, 1, 0, 0.5)  # Green with 50% transparency
			if grid_location == goblin.current_position():
				continue
			var tile_pixel_position = tile_map_layer.map_to_local(grid_location) + Vector2(8, 8)
			draw_rect(
				Rect2(get_screen_position(tile_pixel_position) - Vector2(6, 6), Vector2(12, 12)),
				color
			)
	
	
func draw_move_range(draw_move_phase: String):
	phase = draw_move_phase
	if phase == "start":
		move_range = PathfindingManager.plan_movement_draw_cells(goblin.current_position(), 5)
	queue_redraw()
	
func get_selected_tile():
	return _selected_tile
	
	
func set_selected_tile(selected_tile: Vector2i) -> void:
	_selected_tile = selected_tile
	
func _input(event):
	pass
	
	
func _discern_tile_to_be_selected_from_directional_input(input: String):
	if input == "MoveLeft":
		var new_selected_tile = Vector2i(_selected_tile.x - 1, _selected_tile.y)
		if move_range.has(new_selected_tile) and new_selected_tile != move_range[0]:
			_selected_tile = new_selected_tile
		elif new_selected_tile == move_range[0]:
			new_selected_tile = Vector2i(_selected_tile.x - 2, _selected_tile.y)
			_selected_tile = new_selected_tile
		else:
			var max_x = -INF
			for tile in move_range:
				if tile.y == new_selected_tile.y:
					max_x = max(max_x, tile.x)
			_selected_tile = Vector2i(max_x, new_selected_tile.y)
			
	if input == "MoveRight":
		var new_selected_tile = Vector2i(_selected_tile.x + 1, _selected_tile.y)
		if move_range.has(new_selected_tile) and new_selected_tile != move_range[0]:
			_selected_tile = new_selected_tile
		elif new_selected_tile == move_range[0]:
			new_selected_tile = Vector2i(_selected_tile.x + 2, _selected_tile.y)
			_selected_tile = new_selected_tile
		else:
			var min_x = INF
			for tile in move_range:
				if tile.y == new_selected_tile.y:
					min_x = min(min_x, tile.x)
			_selected_tile = Vector2i(min_x, new_selected_tile.y)
			
	if input == "MoveUp":
		var new_selected_tile = Vector2i(_selected_tile.x, _selected_tile.y - 1)
		if move_range.has(new_selected_tile) and new_selected_tile != move_range[0]:
			_selected_tile = new_selected_tile
		elif new_selected_tile == move_range[0]:
			new_selected_tile = Vector2i(_selected_tile.x, _selected_tile.y - 2)
			_selected_tile = new_selected_tile
		else:
			var max_y = -INF
			for tile in move_range:
				if tile.x == new_selected_tile.x:
					max_y = max(max_y, tile.y)
			_selected_tile = Vector2i(new_selected_tile.x, max_y)
			
	if input == "MoveDown":
		var new_selected_tile = Vector2i(_selected_tile.x, _selected_tile.y + 1)
		if move_range.has(new_selected_tile) and new_selected_tile != move_range[0]:
			_selected_tile = new_selected_tile
		elif new_selected_tile == move_range[0]:
			new_selected_tile = Vector2i(_selected_tile.x, _selected_tile.y + 2)
			_selected_tile = new_selected_tile
		else:
			var min_y = INF
			for tile in move_range:
				if tile.x == new_selected_tile.x:
					min_y = min(min_y, tile.y)
			_selected_tile = Vector2i(new_selected_tile.x, min_y)
		
		
func get_screen_position(event_position: Vector2):
	var canvas_transform = get_global_transform_with_canvas().affine_inverse()
	return event_position + canvas_transform[2]
