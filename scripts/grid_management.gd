extends Node3D

@export var Grid_scenes: Array[PackedScene] 
var mesh_lib_src : MeshLibrary = preload("res://assets/grid_blocks/tileMap.tres")

@onready var navigation_region= $"../NavigationRegion3D"

signal grid_generated(size)

var chunk_size = 64
var preGenSize = 128


var gridmap:GridMap

func _ready():
	
	

	gridmap=GridMap.new()
	add_child(gridmap)
	gridmap.set_cell_size(Vector3(1, 1, 1))
	gridmap.set_cell_scale(1)
	gridmap.set_center_x(true)
	gridmap.set_center_y(true)
	gridmap.set_center_z(true)
	gridmap.set_mesh_library(mesh_lib_src)
	gridmap.name = "BaseGrid"
	
	gridmap.global_position = gridmap.global_position - Vector3(0, 1, 0)

	for x in range(-preGenSize, preGenSize + 1):
		for z in range(-preGenSize, preGenSize + 1):
			var grass_pos = Vector3i(x, 1, z)
			var dirt_pos = Vector3i(x, 0, z)
			gridmap.set_cell_item(grass_pos, 0)
			gridmap.set_cell_item(dirt_pos, 8)
			
			
	
	grid_generated.emit(preGenSize)



		
			
		
			
			
	
	

func _process(delta):
	pass
