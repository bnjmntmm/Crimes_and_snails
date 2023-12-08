extends Node3D
@export var Grid_scenes: Array[PackedScene] 

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var randomGridInt = randi_range(0, Grid_scenes.size()-1)
	var newGrid = Grid_scenes[randomGridInt].instantiate()
	add_child(newGrid)
	global_position = global_position - Vector3(0,2,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
