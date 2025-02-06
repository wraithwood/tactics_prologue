extends Control

@onready var options = [$AttackButton, $Button]
@onready var arrow = $TextureRect

var current_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_arrow_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if TurnManager.turn_phase == TurnManager.MENU_ROOT_PHASE:
		if options[0].button_pressed:
			current_index = 0
			_on_move_button_pressed()
			_update_arrow_position()
			return
	
		if options[1].button_pressed:
			current_index = 1
			_on_move_button_pressed()
			_update_arrow_position()
			return
	
		if Input.is_action_just_pressed("MoveUp"):
			_move_selection(-1)
		if Input.is_action_just_pressed("MoveDown"):
			_move_selection(1)
		
		if Input.is_action_just_pressed("UiAccept"):
			_select_option()
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		for child in get_children():
			if child is Button:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
				child.focus_mode = Control.FOCUS_NONE  # Prevents focus when clicked
		

func _move_selection(direction: int) -> void:
	current_index += direction
	if current_index < 0:
		current_index = options.size() - 1
	elif current_index >= options.size():
		current_index = 0
		
	_update_arrow_position()
	
	
func _update_arrow_position() -> void:
	var target_button = options[current_index]
	arrow.position = target_button.position - Vector2(20, 0)
	
	
func _select_option() -> void:
	match current_index:
		0:
			print("Attack Selected")
		1:
			_on_move_button_pressed()
			
			
func _on_move_button_pressed() -> void:
	TurnManager.turn_phase = TurnManager.PLAN_MOVE_PHASE
