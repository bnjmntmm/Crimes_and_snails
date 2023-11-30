extends Node3D

enum State{
	PLAY,
	BUILDING,
	POV_MODE
}

var current_state=State.PLAY

var Players = {}

var GridMaps = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
