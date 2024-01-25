extends Node3D
@onready var navigation_region_3d = $NavigationRegion3D

@onready var plane_mesh := preload("res://scenes/plane_adding/plane.tscn")
@onready var play_area =$PlayArea





# Called when the node enters the scene tree for the first time.

signal grid_generated()


var chunk_size = 64
var preGenSize = 128

var offset = 64
var instances = 6

func _ready():
	for x in range(-preGenSize,preGenSize+1,offset):
		for z in range(-preGenSize,preGenSize+1,offset):
			var plane_intantiate = plane_mesh.instantiate()
			plane_intantiate.global_position = Vector3(x,1.5,z)
			play_area.add_child(plane_intantiate,true)
			#call_deferred("emit",grid_generated, plane_intantiate)
			grid_generated.emit(plane_intantiate)
			
#	var gridmap : GridMap = GridMap.new()
#	add_child(gridmap)
#	#gridmap.set_bake_navigation(true)
#	#addNav()
#	gridmap.set_cell_size(Vector3(1,1,1))
#	gridmap.set_cell_scale(1.001)
#	gridmap.set_center_x(true)
#	gridmap.set_center_y(true)
#	gridmap.set_center_z(true)
#	gridmap.set_mesh_library(mesh_lib_src)
#	gridmap.name = "BaseGrid"
#
#	gridmap.global_position = gridmap.global_position - Vector3(0,1,0)
#
#	for x in range(-preGenSize, preGenSize):
#		for z in range(-preGenSize, preGenSize):
#			var grass_pos = Vector3i(x,1,z)
#			var dirt_pos = Vector3i(x,0,z)
#			gridmap.set_cell_item(grass_pos, 0)
#			gridmap.set_cell_item(dirt_pos, 1)
	
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
