extends Node3D
class_name Fire
var fire_shader = preload("res://assets/textures/shader/fire_shader.tscn")
var isBurning := false
var isExtinguished := false
var isDestroyed := false
var currentHouse

signal sabotage_stopped
@onready var random_events = $".."

var burningTimer : Timer

var houseFireDict = {}

func _ready():
	burningTimer = Timer.new()
	burningTimer.wait_time = 15.0
	burningTimer.timeout.connect(destroyHouse)
	add_child(burningTimer)



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
	currentHouse = houseFireDict[house]
	burningTimer.start()

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
	currentHouse = null
	burningTimer.stop()

func destroyHouse():
	var plane_to_bake = currentHouse.old_plane
	currentHouse.fire_scene.queue_free()
	
	if currentHouse.name.contains("stock"):
		GameManager.stock_array.erase(currentHouse)
	if currentHouse.name.contains("Terrarium"):
		GameManager.terrariumsPlaced -= 1
		GameManager.calculateNewMaxSnailAmount()
	if currentHouse.name.contains("House"):
		GameManager.houses_built-=1
	currentHouse.queue_free()
	plane_to_bake.bake_nav()
	sabotage_stopped.emit()
