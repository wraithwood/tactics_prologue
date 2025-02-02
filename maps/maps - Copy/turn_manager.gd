extends Node2D

@onready var goblin = get_parent().get_node("Goblin")
@onready var soldier = get_parent().get_node("Soldier")

var turn_order = {
	"goblin": false,
	"soldier": false
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turn_order["goblin"] = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("Turn Order: ", turn_order)
	
	
func is_my_turn(name: String) -> bool:
	return turn_order[name]
	
func turn_is_complete(name: String) -> void:
	if not turn_order.has(name):
		print("Error: Turn name does not exist in turn_order.")
		return
		
	turn_order[name] = false
	for key in turn_order:
		if key != name:
			turn_order[key] = true
			break  # Stop after assigning the next turn
	
	print("Turn order updated:", turn_order)
