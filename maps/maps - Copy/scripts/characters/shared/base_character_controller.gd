extends Sprite2D

class_name BaseCharacterController

@export var UNIQUE_NAME: String = ""
@export var stats: Dictionary = {
	"hp": 0,
	"mana": 0,
	"strength": 0,
	"intelligence": 0,
	"speed": 0
}

@onready var tile_map_layer: TileMapLayer = get_parent().get_node("TileLayers/Grass")
@onready var plan_movement_renderer = $PlanMovementDraw
var is_initial_move_to_correct_draw: bool = false
var is_moving: bool = false
var current_path: Array = []
var drawing_movement: bool = false


func _ready() -> void:
	if UNIQUE_NAME == "":
		push_error("UNIQUE_NAME must be defined in child classes")
		

func _on_move_to_tile(tile: Vector2i) -> void:
	current_path = PathfindingManager.find_path(current_position(), tile)
	print("Current Path: ", current_path)
	is_moving = true
	current_path.remove_at(0)
	_update_movement()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if TurnManager.is_my_turn(UNIQUE_NAME) and not current_path.is_empty() and is_moving:
		_update_movement()
	
	if TurnManager.is_my_turn(UNIQUE_NAME) and TurnManager.turn_phase == TurnManager.PLAN_MOVE_PHASE and not drawing_movement:
		drawing_movement = true
		plan_movement_renderer.draw_move_range("start")


func _update_movement() -> void:
	if is_moving and not current_path.is_empty():
		update_movement_dangerous()
				
				
func current_position() -> Vector2i:
	return tile_map_layer.local_to_map(position - PathfindingManager.TILE_SIZE / 2)
	

# This function is dangerous. It will not respect turn orders.
func update_movement_dangerous() -> void:
	print("Moving toward grid location: ", current_path[0])
	var pixel_position_destination = tile_map_layer.map_to_local(current_path[0]) + PathfindingManager.TILE_SIZE / 2
	print("That grid location resolved to this pixel location: ", pixel_position_destination)
	position = position.move_toward(pixel_position_destination, 1)
	if position.distance_to(pixel_position_destination) < 0.1:
		print("Removing the tile destination from current_path as it has been satisfied: ", current_path[0])
		current_path.remove_at(0)
		if current_path.is_empty():
			is_moving = false
			if !is_initial_move_to_correct_draw:
				TurnManager.turn_is_complete(UNIQUE_NAME)
			is_initial_move_to_correct_draw = false
			TurnManager.turn_phase = TurnManager.MENU_ROOT_PHASE
			drawing_movement = false
