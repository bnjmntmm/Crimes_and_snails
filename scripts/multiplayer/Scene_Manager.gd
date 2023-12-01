extends Node3D

@export var PlayerScene : PackedScene

@export var Grid_scenes: Array[PackedScene] 

var hud = preload("res://world/player/hud/hud.tscn")




var positions = [Vector3(-400,-1,-400), Vector3(-400, -1, 400), Vector3(400,-1,-400), Vector3(400,-1,400)]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in GameManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		add_child(currentPlayer)	
	for j in range(GameManager.Players.size()):
		var player = get_tree().root.get_node("/root/World/").get_node(str(GameManager.Players.keys()[j]))
		if player.is_multiplayer_authority():
			var randomGridInt = randi_range(0, Grid_scenes.size()-1)
			spawnWorld.rpc(randomGridInt, j)
		player.global_position = positions[j]
#		var newGrid = Grid_scenes[randomGridInt].instantiate()
#		newGrid.name = "GRID_FOR_" + str(GameManager.Players.keys()[j])
#		newGrid.spawnedbyID = GameManager.Players.keys()[j]
#		newGrid.global_position = positions[j]
#		add_child(newGrid)


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


@rpc("any_peer", "call_local")
func spawnWorld(indexGrid, playerIndex):
	var newGrid = Grid_scenes[indexGrid].instantiate()
	newGrid.name = "GRID_FOR_" + str(GameManager.Players.keys()[playerIndex])
	newGrid.spawnedbyID = GameManager.Players.keys()[playerIndex]
	newGrid.global_position = positions[playerIndex]
	add_child(newGrid)
	print("new grid added")
