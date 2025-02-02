extends Node2D

@onready var goblin = get_parent().get_node("Goblin")
@onready var soldier = get_parent().get_node("Soldier")

var turn_order = {
	"goblin": false,
	"soldier": false
}

const MENU_ROOT_PHASE: int = 0
const PLAN_MOVE_PHASE: int = 1 
const ATTACK_PHASE: int = 2
const MOVE_PHASE: int = 3
const ACT: int = 5

# IF PLAYER CHARACTER, SET TURN PHASE TO 0 INITIALLY
# FOR AI CHARACTERS, SET TURN PHASE TO 3 INITIALLY
var turn_phase = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turn_order["goblin"] = true
	
	
func is_my_turn(character_name: String) -> bool:
	return turn_order[character_name]
	
	
func turn_is_complete(character_name: String) -> void:
	if not turn_order.has(character_name):
		print("Error: Turn name does not exist in turn_order.")
		return
		
	turn_order[character_name] = false
	for key in turn_order:
		if key != character_name:
			turn_order[key] = true
			break  # Stop after assigning the next turn
	
	print("Turn order updated:", turn_order)


func enter_plan_move_phase() -> void:
	turn_phase = PLAN_MOVE_PHASE
	
	
func enter_attack_phase() -> void:
	turn_phase = ATTACK_PHASE
	
	
func enter_move_phase() -> void:
	turn_phase = MOVE_PHASE
		
