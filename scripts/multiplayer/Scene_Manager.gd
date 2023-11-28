extends Node3D

@export var PlayerScene : PackedScene
var grid = preload("res://assets/models/3d_tilemap/scenes/grid_one.tscn")
var hud = preload("res://world/player/hud/hud.tscn")




var positions = [Vector3(-400,-1,-400), Vector3(-400, -1, 400), Vector3(400,-1,-400), Vector3(400,-1,400)]

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
		
		#disableAllLayersForCamera(currentPlayer)
		
		#if currentPlayer.get_child(2).name == "Camera3D":
			#currentPlayer.get_child(2).set_cull_mask_value(index+2, true)
		#currentPlayer.camera.set_cull_mask_value()
		add_child(currentPlayer)
		currentPlayer.global_position = gridMap.global_position + Vector3(0,4,0)
		
#		var hud_item = hud.instantiate()
#		currentPlayer.add_child(hud_item)
#		hud_item.name = "Hud_For_" + str(GameManager.Players[i].id)
#		hud_item.visible = true
		if currentPlayer.is_multiplayer_authority():
			pass
			
			#name_value.text=GameManager.Players[i].name
			#hud_item.get_child(0).get_child(0).get_child(1).text=GameManager.Players[i].name
		#changeVisibilityLayers(hud_item, index)
		#print(currentPlayer.is_multiplayer_authority())
#		if currentPlayer.is_multiplayer_authority():
#			hud_item.visible = true
		#setHud(hud_item, GameManager.Players[i])
		
		#add_child(hud_item)
		index +=1
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func disableAllLayersForCamera(currentplayer):
#	if currentplayer.get_child(2).name == 'Camera3D':
#		for i in range(1,21):
#			currentplayer.get_child(2).set_cull_mask_value(i,false)
#		currentplayer.get_child(2).set_cull_mask_value(1,true)

#func changeVisibilityLayers(hud: SubViewportContainer, index):
#	hud.set_visibility_layer_bit(index+1,true)
	
#	#VBoxContainer
#	hud.get_child(0).get_child(0).set_visibility_layer_bit(index-1,true)
#	#HBoxContainer1
#	hud.get_child(0).get_child(0).get_child(0).set_visibility_layer_bit(index-1,true)
#	hud.get_child(0).get_child(0).get_child(0).get_child(0).set_visibility_layer_bit(index-1,true)
#	hud.get_child(0).get_child(0).get_child(0).get_child(1).set_visibility_layer_bit(index-1,true)
#	#HBoxContainer2
#	hud.get_child(0).get_child(0).get_child(1).set_visibility_layer_bit(index-1,true)
#	hud.get_child(0).get_child(0).get_child(1).get_child(0).set_visibility_layer_bit(index-1,true)
#	hud.get_child(0).get_child(0).get_child(1).get_child(1).set_visibility_layer_bit(index-1,true)
#	#HBoxContainer3
#	hud.get_child(0).get_child(0).get_child(2).set_visibility_layer_bit(index-1,true)
#	hud.get_child(0).get_child(0).get_child(2).get_child(0).set_visibility_layer_bit(index-1,true)
#	hud.get_child(0).get_child(0).get_child(2).get_child(1).set_visibility_layer_bit(index-1,true)
#	hud.get_child(0).get_child(0).get_child(2).get_child(2).set_visibility_layer_bit(index-1,true)

#func setHud(hud: SubViewportContainer,playerId):
#	hud.get_child(0).get_child(0).get_child(0).get_child(1).text = playerId.name
	#hud.get_child(0).get_child(0).get_child(1).text = playerId.name
	#hud.get_child(0).get_child(1).get_child(1).text = str(GameManager.Players.size())



