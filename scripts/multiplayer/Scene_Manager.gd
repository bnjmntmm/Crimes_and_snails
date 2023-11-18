extends Node3D

@export var PlayerScene : PackedScene
var grid = preload("res://assets/models/3d_tilemap/scenes/grid_one.tscn")
var waterPlane = preload("res://world/world_scene/water_parent.tscn")
var positions = [Vector3(-400,-1,-400), Vector3(-400, -1, 400), Vector3(400,-1,-400), Vector3(400,-1,400)]

# Called when the node enters the scene tree for the first time.
func _ready():
#	if GameManager.WorldGenerated == true:
#		randomize()
#		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
#			spawn.global_position = Vector3(randi_range(-40,40),2,randi_range(-40,40))
	
	var index = 0
	for i in GameManager.Players:
		var gridMap = grid.instantiate()
		var waterArea = waterPlane.instantiate()
		gridMap.name = "Grid_For_" + str(GameManager.Players[i].id)
		waterArea.name = "WaterPlane_for_" + str(GameManager.Players[i].id)
		add_child(gridMap)
		add_child(waterArea)
		gridMap.global_position = positions[index]
		waterArea.global_position = (gridMap.global_position - Vector3(0,0.5,0))
		#print(gridMap.global_position)
		
		
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		add_child(currentPlayer)
		currentPlayer.global_position = gridMap.global_position + Vector3(0,4,0)
#		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
#			if spawn.name == str(index):
#				currentPlayer.global_position = spawn.global_position
		index +=1
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
