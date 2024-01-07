extends Node3D

var tornado_scene = preload("res://assets/textures/shader/tornado.tscn")

@export var spawn_radius = 20
var spawn_angle = randf_range(0,2*PI)

var houseTornadoDict = {}

func travel_to_house(house):
	var currentHouse = BuildManager.HouseObj.new()
	currentHouse.staticbody = house
	houseTornadoDict[house.name] = currentHouse
	houseTornadoDict[house.name].isTornado = true
	var currentTornadoObject = houseTornadoDict[house.name].staticbody
	randomize()
	var new_tornado = tornado_scene.instantiate()
	houseTornadoDict[house.name].tornado_scene = new_tornado
	add_child(new_tornado)
	new_tornado.target = house
	var spawn_x = currentTornadoObject.global_position.x + spawn_radius * cos(spawn_angle)
	var spawn_z = currentTornadoObject.global_position.z + spawn_radius * sin(spawn_angle)
	
	new_tornado.global_position.x = spawn_x
	new_tornado.global_position.z = spawn_z
	new_tornado.global_position.y = 1
	new_tornado.ready_to_move = true
	
func stop_tornado(house):
	houseTornadoDict[house.name].isTornado = false
	
	if houseTornadoDict[house.name].tornado_scene.body_freed:
		houseTornadoDict[house.name].tornado_scene.queue_free()
		houseTornadoDict[house.name].tornado_scene = null
		houseTornadoDict[house.name].staticbody.queue_free()
	else:
		houseTornadoDict[house.name].tornado_scene.queue_free()
		houseTornadoDict[house.name].tornado_scene = null
