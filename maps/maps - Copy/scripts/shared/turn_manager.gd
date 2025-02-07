extends Node2D

@onready var goblin = get_parent().get_node("Goblin")
@onready var soldier = get_parent().get_node("Soldier")

var turn_order = {
}

const MENU_ROOT_PHASE: int = 0
const PLAN_MOVE_PHASE: int = 1 
const ATTACK_PHASE: int = 2
const MOVE_PHASE: int = 3
const PLAN_ATTACK_PHASE: int = 4
const ACT: int = 5

# IF PLAYER CHARACTER, SET TURN PHASE TO 0 INITIALLY
# FOR AI CHARACTERS, SET TURN PHASE TO 3 INITIALLY
var turn_phase = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

func _process(_delta: float) -> void:
	for entry in TurnManager.turn_order.values():
		if entry["is_turn"] == true and entry["is_player"] == false and TurnManager.turn_phase != TurnManager.ACT:
			TurnManager.turn_phase = TurnManager.ACT
	
	
func is_my_turn(character_name: String) -> bool:
	if !TurnManager.turn_order.has(character_name):
		return false
		
	return TurnManager.turn_order[character_name]["is_turn"]
	
	
func turn_is_complete(character_name: String) -> void:
	if not TurnManager.turn_order.has(character_name):
		print("Error: Turn name does not exist in turn_order.")
		return
		
	TurnManager.turn_order[character_name]["is_turn"] = false
	for key in TurnManager.turn_order:
		if key != character_name:
			TurnManager.turn_order[key]["is_turn"] = true
			break  # Stop after assigning the next turn
	
	print("Turn order updated:", TurnManager.turn_order)
	
	
func register_character(character_name: String, is_player: bool) -> void:
	TurnManager.turn_order[character_name] = {
		"is_turn": false,
		"is_player": is_player
	}
	var is_player_turn_values = []
	for entry in TurnManager.turn_order.values():
		is_player_turn_values.append(entry["is_turn"])
	
	var all_false = true
	
	for value in is_player_turn_values:
		if value:
			all_false = false
			break
			
	if all_false:
		var first_key = TurnManager.turn_order.keys()[0]
		TurnManager.turn_order[first_key]["is_turn"] = true


func enter_plan_move_phase() -> void:
	TurnManager.turn_phase = TurnManager.PLAN_MOVE_PHASE
	
	
func enter_attack_phase() -> void:
	TurnManager.turn_phase = TurnManager.ATTACK_PHASE
	
	
func enter_move_phase() -> void:
	TurnManager.turn_phase = TurnManager.MOVE_PHASE
	

func enter_menu_root_phase() -> void:
	TurnManager.turn_phase == TurnManager.MENU_ROOT_PHASE
		
