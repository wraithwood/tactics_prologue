extends Node2D

var pathfinding: PathfindingManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pathfinding = PathfindingManager
	add_child(pathfinding)
