extends Node2D

@onready var layer: TileMapLayer = $TileLayers/Pathfinding


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(_event):
	pass
	#if event is InputEventMouseButton:
		#var grid_position = layer.local_to_map(event.position)
		#print("GRID POSITION (Vector2i): ", grid_position)
		#
		#
		#print("Mouse Position (get global mouse position):", $Camera2D.get_global_mouse_position())
		
		
