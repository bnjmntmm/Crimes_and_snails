extends Node3D
class_name Fire
var fire_shader = preload("res://assets/textures/shader/fire_shader.tscn")
var isBurning := false
var isExtinguished := false
var isDestroyed := false
signal sabotage_stopped
@onready var random_events = $".."

var houseFireDict = {}




func execute_sabotage_to(house):
	houseFireDict[house] = house
	houseFireDict[house].isBurning = true
	#print(houseFireDict[house.name].isBurning)
	house.audio_stream_player.play(0)
	set_fire_to_object(house)
	
func set_fire_to_object(house):
	var currentBurningObject = houseFireDict[house]
	var newFire = fire_shader.instantiate()
	houseFireDict[house].fire_scene = newFire
	add_child(newFire,true)
	print("Feuer started " + str(houseFireDict[house]))
	newFire.global_position = currentBurningObject.get_fire_spot_location()

func add_label_to_building(currentBurningObject):
	var newLabel = Label3D.new()
	add_child(newLabel)
	newLabel.billboard = true
	newLabel.global_position = currentBurningObject.global_position + Vector3(0,20,0)
	newLabel.font_size = 100
	newLabel.text = "BURNING!"
	print(newLabel.global_position)

func fire_stopped(house):
	sabotage_stopped.emit()
	print("Feuer ended: "  + str(houseFireDict[house]))
	houseFireDict[house].isBurning = false
	houseFireDict[house].fire_scene.emitting = false
	houseFireDict[house].fire_scene.queue_free()
	houseFireDict[house].fire_scene = null
	house.audio_stream_player.stop()
	random_events.start_sabotage_timer()
