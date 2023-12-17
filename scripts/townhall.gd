extends Node3D


@export var citizen:PackedScene
var current_citizen
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func run_spawn():
	var citizen=citizen.instantiate()
	current_citizen=citizen
	citizen.spawn_point=$SpawnPoint
	get_tree().root.add_child(citizen,true)
	citizen.global_position=$SpawnPoint.global_position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
