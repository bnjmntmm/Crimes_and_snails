extends Node3D

var tornado_scene = preload("res://assets/textures/shader/tornado.tscn")

@export var spawn_radius = 20
var spawn_angle = randf_range(0,2*PI)
signal sabotage_stopped

var houseTornadoDict = {}

func travel_to_house(house):
	houseTornadoDict[house] = house
	houseTornadoDict[house].isTornado = true
	var currentTornadoObject = houseTornadoDict[house]
	randomize()
	var new_tornado = tornado_scene.instantiate()
	houseTornadoDict[house].tornado_scene = new_tornado
	
	### TORNADO GOES WRONG DIR ATM
	add_child(new_tornado)
	new_tornado.target = house
	var spawn_x = currentTornadoObject.global_position.x + spawn_radius * cos(spawn_angle)
	var spawn_z = currentTornadoObject.global_position.z + spawn_radius * sin(spawn_angle)
	
	new_tornado.global_position.x = spawn_x
	new_tornado.global_position.z = spawn_z
	new_tornado.global_position.y = 2
	new_tornado.ready_to_move = true
	
func stop_tornado(house):
	sabotage_stopped.emit()
	houseTornadoDict[house].isTornado = false
	
	if houseTornadoDict[house].tornado_scene.body_freed:
		houseTornadoDict[house].tornado_scene.queue_free()
		houseTornadoDict[house].tornado_scene = null
		var plane_ref = houseTornadoDict[house].old_plane
		houseTornadoDict[house].queue_free()
		plane_ref.bake_nav()
	else:
		houseTornadoDict[house].tornado_scene.queue_free()
		houseTornadoDict[house].tornado_scene = null
