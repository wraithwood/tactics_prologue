extends BaseCharacterController

@onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UNIQUE_NAME = "goblin"
	TurnManager.register_character(UNIQUE_NAME, true)
	var pf_registered = PathfindingManager.register_character(self, Vector2i(15, 15))
	if pf_registered:
		position = tile_map_layer.map_to_local(Vector2i(15, 15))
		current_path = [Vector2i(15, 15)]
		is_initial_move_to_correct_draw = true
		is_moving = true
		# Move him to the same square once to fix where he is rendered in the tile
		_update_movement()
	animation_player.get_animation("idle").loop = true
	animation_player.play("idle")
	plan_movement_renderer.connect("move_to_tile", _on_move_to_tile)
