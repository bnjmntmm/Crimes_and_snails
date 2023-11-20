extends Control

@export var Address = "127.0.0.1"
@export var port = 8910
var enet_peer = ENetMultiplayerPeer.new()

var Player = preload("res://world/player/Player.tscn")
@onready var allPlayersLabel = $VBoxContainer/HBoxContainer2/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func peer_connected(id):
	print("Player Connected: " + str(id))
	
func peer_disconnected(id):
	print("Player disonnected: " + str(id))
	if GameManager.Players[id].name in allPlayersLabel.text:
		var txt = allPlayersLabel.text
		txt = txt.replace(GameManager.Players[id].name, "")
		allPlayersLabel.text = txt
	GameManager.Players.erase(GameManager.Players[id])
func connected_to_server():
	print("Connected!")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())
func connection_failed(id):
	print("connection failed")

@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id,
			"gold": 0
		}
		
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)
			lobbyNames.rpc()
			

@rpc("any_peer", "call_local")
func lobbyNames():
	allPlayersLabel.text = ""
	for i in GameManager.Players:
		allPlayersLabel.text +=  GameManager.Players[i].name +"\n"

func _on_host_button_down():
	var error = enet_peer.create_server(port,4)
	if error != OK:
		print("cannot host: " + error)
		return
	enet_peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(enet_peer)
	print("Waiting for Players!")
	SendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())
	
	pass # Replace with function body.


func _on_join_button_down():
	enet_peer.create_client(Address, port)
	enet_peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(enet_peer)
	pass # Replace with function body.

@rpc("any_peer", "call_local")
func StartGame():
	var scene = load("res://world/world_scene/world.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _on_start_game_button_down():
	StartGame.rpc()
	pass # Replace with function body.
