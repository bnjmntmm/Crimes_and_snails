extends Node3D

@export var PlayerScene : PackedScene
var grid = preload("res://assets/models/3d_tilemap/scenes/grid_one.tscn")
var hud = preload("res://world/player/hud/hud.tscn")




var positions = [Vector3(-400,-1,-400), Vector3(-400, -1, 400), Vector3(400,-1,-400), Vector3(400,-1,400)]

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in GameManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		add_child(currentPlayer)
		var gridMap = grid.instantiate()
		gridMap.visible = true
		gridMap.name = "Grid_For_" + str(GameManager.Players[i].id)
		gridMap.spawnedbyID = GameManager.Players[i].id
		add_child(gridMap)
		gridMap.global_position = positions[index]
		currentPlayer.global_position = gridMap.global_position + Vector3(0,2,0)
		
		if currentPlayer.is_multiplayer_authority():
			gridMap.generatedSeed = GameManager.Players[i].worldSeed
			gridMap.generate_world(gridMap.generatedSeed)

		if currentPlayer.is_multiplayer_authority():
			pass
		index +=1
	for i in GameManager.GridMaps:
		var grid= get_node("/root/World/Grid_For_" + str(i))
		print(grid)
		var gridMap : GridMap = grid.get_child(2)

#for i in GameManager.Players:
#		var gridMap = grid.instantiate()
#		gridMap.name = "Grid_For_" + str(GameManager.Players[i].id)
#		gridMap.spawnedbyID = GameManager.Players[i].id
#		add_child(gridMap)
#		gridMap.global_position = positions[index]
#		#print(gridMap.global_position)
#		var currentPlayer = PlayerScene.instantiate()
#		currentPlayer.name = str(GameManager.Players[i].id)
#		add_child(currentPlayer)	
#		currentPlayer.global_position = gridMap.global_position + Vector3(0,4,0)
#		if currentPlayer.is_multiplayer_authority() and gridMap.spawnedbyID == GameManager.Players[i].id:
#			gridMap.generatedSeed = GameManager.Players[i].worldSeed
#			gridMap.generate_world(gridMap.generatedSeed)
#
#
#		index +=1

#	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

