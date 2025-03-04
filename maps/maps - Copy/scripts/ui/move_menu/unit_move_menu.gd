extends Control
class_name MoveMenu

# Let whatever is using the move menu subscribe to move requests generated by the menu.
signal player_move(direction: Enums.Direction)


# Load references to the various buttons into variables when the node is ready.
@onready var up_button: TextureButton = $move_up
@onready var down_button: TextureButton = $move_down
@onready var left_button: TextureButton = $move_left
@onready var right_button: TextureButton = $move_right


func _ready() -> void:
	# Connect the buttons to the `_on_button_pressed` method, along with their corresponding direction.
	up_button.pressed.connect(func(): _on_button_pressed(Enums.Direction.Up))
	down_button.pressed.connect(func(): _on_button_pressed(Enums.Direction.Down))
	left_button.pressed.connect(func(): _on_button_pressed(Enums.Direction.Left))
	right_button.pressed.connect(func(): _on_button_pressed(Enums.Direction.Right))


func _on_button_pressed(direction: Enums.Direction) -> void:
	print(direction)
	# Make sure to notify whoever is subscribed to the `player_move` signal that a move button was pressed.
	player_move.emit(direction)
