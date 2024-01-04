extends Node3D
class_name Fire
var fire_shader = preload("res://assets/textures/shader/fire_shader.tscn")
var isBurning := false
var isExtinguished := false
var isDestroyed := false

var houseFireDict = {}

class HouseObj:
	var staticbody : StaticBody3D = null
	var fire_scene = null
	var isBurning : bool = false
	var isDestroyed: bool = false

func execute_sabotage_to(house):
	var currentHouse = HouseObj.new()
	currentHouse.staticbody = house
	houseFireDict[house.name] = currentHouse
	houseFireDict[house.name].isBurning = true
	#print(houseFireDict[house.name].isBurning)
	set_fire_to_object(house.name)
	
func set_fire_to_object(HouseName):
	var currentBurningObject = houseFireDict[HouseName].staticbody
	var newFire = fire_shader.instantiate()
	houseFireDict[HouseName].fire_scene = newFire
	add_child(newFire,true)
	newFire.global_position = currentBurningObject.global_position + Vector3(0,15,0)

func add_label_to_building(currentBurningObject):
	var newLabel = Label3D.new()
	add_child(newLabel)
	newLabel.billboard = true
	newLabel.global_position = currentBurningObject.global_position + Vector3(0,20,0)
	newLabel.font_size = 100
	newLabel.text = "BURNING!"
	print(newLabel.global_position)

func fire_stopped(house):
	houseFireDict[house.name].isBurning = false
	houseFireDict[house.name].fire_scene.emitting = false
	houseFireDict[house.name].fire_scene.queue_free()
	houseFireDict[house.name].fire_scene = null
