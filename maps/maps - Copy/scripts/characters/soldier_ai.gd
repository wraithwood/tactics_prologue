extends BaseCharacterController

@onready var player = get_parent().get_node("Goblin")
@onready var path_manager = get_parent().get_node("PathfindingManager")
const PRIORITIES: Array = [
	"damage_player"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UNIQUE_NAME = "soldier"
	TurnManager.register_character(UNIQUE_NAME, false)
	var pf_registered = PathfindingManager.register_character(self, Vector2i(18, 18))
	if pf_registered:
		position = tile_map_layer.map_to_local(Vector2i(18, 18))
		current_path = PathfindingManager.find_path(current_position(), Vector2i(19, 19))
		print("In PF Registered: ", current_path)
		update_movement_dangerous()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if TurnManager.is_my_turn(UNIQUE_NAME) and not is_moving:
		_on_move_to_tile(Vector2i(19, 19))
		
	if TurnManager.is_my_turn(UNIQUE_NAME) and is_moving:
		_update_movement()

	
func _player_current_position() -> Vector2:
	return tile_map_layer.local_to_map(player.global_position - path_manager.TILE_SIZE / 2)
		
	
func _arrange_priorities_based_on_context():
	pass
	# things to consider:
	# All character's HP (finish off weak player characters, run if low hp self etc)
	# terrain (height, putting obstacles between self and player in advantageous way)
	# people willing to help (flank positions)
	# 
