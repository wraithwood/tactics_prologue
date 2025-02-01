extends Node2D

var pathfinding: PathfindingManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pathfinding = PathfindingManager.new()
	add_child(pathfinding)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
