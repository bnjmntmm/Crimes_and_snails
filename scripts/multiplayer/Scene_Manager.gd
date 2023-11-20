extends Node3D

@export var PlayerScene : PackedScene
var grid = preload("res://assets/models/3d_tilemap/scenes/grid_one.tscn")
var positions = [Vector3(-400,-1,-400), Vector3(-400, -1, 400), Vector3(400,-1,-400), Vector3(400,-1,400)]
@onready var name_value = $Control/VBoxContainer/HBoxContainer/NameValue
@onready var connected_value = $Control/VBoxContainer/HBoxContainer2/ConnectedValue
@onready var gold_user = $Control/VBoxContainer/HBoxContainer3/Gold_User

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var index = 0
	for i in GameManager.Players:
		var gridMap = grid.instantiate()
		gridMap.name = "Grid_For_" + str(GameManager.Players[i].id)
		add_child(gridMap)
		gridMap.global_position = positions[index]
		#print(gridMap.global_position)
		
		
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		add_child(currentPlayer)
		currentPlayer.global_position = gridMap.global_position + Vector3(0,4,0)
		index +=1
	connected_value.text = str(index)
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
