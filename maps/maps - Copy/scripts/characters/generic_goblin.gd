extends Sprite2D

@onready var animation_player = $AnimationPlayer
@onready var pathfinding_manager = get_parent().get_node("PathfindingManager")
@onready var tile_map_layer: TileMapLayer = get_parent().get_node("TileLayers/Pathfinding")
@onready var turn_manager: Node2D = get_parent().get_node("TurnManager")
var is_moving: bool = false
var current_path: Array = []
var has_action: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.get_animation("idle").loop = true
	animation_player.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("Is Goblin's turn? ", turn_manager.is_my_turn("goblin"))
	if not is_moving and turn_manager.is_my_turn("goblin"):
		_on_player_input(delta)
		
	_update_movement(delta)
				
func _on_player_input(delta: float) -> void:
	if Input.is_action_just_pressed("MoveLeft") and not is_moving:
		_move_sprite_left(delta)
	if Input.is_action_just_pressed("MoveRight") and not is_moving:
		_move_sprite_right(delta)
	if Input.is_action_just_pressed("MoveUp") and not is_moving:
		_move_sprite_up(delta)
	if Input.is_action_just_pressed("MoveDown") and not is_moving:
		_move_sprite_down(delta)
		
func _move_sprite(delta: float, current_position: Vector2i, destination: Vector2i) -> void:
	current_path = pathfinding_manager.find_path(current_position, destination)
	if not current_path.is_empty():
		is_moving = true
			
	if is_moving and not current_path.is_empty():
		var pixel_position_destination = tile_map_layer.map_to_local(current_path[0])
		position = position.move_toward(pixel_position_destination, delta * 200)
		
		if position.distance_to(pixel_position_destination) < 1:
			current_path.remove_at(0)
			if current_path.is_empty():
				is_moving = false
				turn_manager.turn_is_complete("goblin")
				
func _move_sprite_left(delta: float) -> void:
	var current_position = _current_position()
	var destination: Vector2i = Vector2i(current_position.x - 1, current_position.y)
	_move_sprite(delta, current_position, destination)
	
func _move_sprite_right(delta: float) -> void:
	var current_position = _current_position()
	var destination: Vector2i = Vector2i(current_position.x + 1, current_position.y)
	_move_sprite(delta, current_position, destination)
	
func _move_sprite_up(delta: float) -> void:
	var current_position = _current_position()
	var destination: Vector2i = Vector2i(current_position.x, current_position.y - 1)
	_move_sprite(delta, current_position, destination)
	
func _move_sprite_down(delta: float) -> void:
	var current_position = _current_position()
	var destination: Vector2i = Vector2i(current_position.x, current_position.y + 1)
	_move_sprite(delta, current_position, destination)

func _update_movement(delta: float) -> void:
	if is_moving and not current_path.is_empty():
		var pixel_position_destination = tile_map_layer.map_to_local(current_path[0]) + pathfinding_manager.tile_size() / 2
		position = position.move_toward(pixel_position_destination, delta * 200)
		
		if position.distance_to(pixel_position_destination) < 1:
			current_path.remove_at(0)
			if current_path.is_empty():
				is_moving = false
				turn_manager.turn_is_complete("goblin")
				
func _current_position() -> Vector2:
	return tile_map_layer.local_to_map(global_position - pathfinding_manager.tile_size() / 2)
