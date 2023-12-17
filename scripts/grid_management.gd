extends Node3D
@export var Grid_scenes: Array[PackedScene] 
var mesh_lib_src : MeshLibrary= preload("res://assets/grid_blocks/tileMap.tres")
@onready var navigation_region_3d = $NavigationRegion3D





# Called when the node enters the scene tree for the first time.

signal grid_generated(size)


var chunk_size = 64
var preGenSize = 128
func _ready():
	
	var gridmap : GridMap = GridMap.new()
	add_child(gridmap)
	#gridmap.set_bake_navigation(true)
	#addNav()
	gridmap.set_cell_size(Vector3(1,1,1))
	gridmap.set_cell_scale(1)
	gridmap.set_center_x(true)
	gridmap.set_center_y(true)
	gridmap.set_center_z(true)
	gridmap.set_mesh_library(mesh_lib_src)
	gridmap.name = "BaseGrid"
	
	gridmap.global_position = gridmap.global_position - Vector3(0,1,0)
	
	for x in range(-preGenSize, preGenSize):
		for z in range(-preGenSize, preGenSize):
			var grass_pos = Vector3i(x,1,z)
			var dirt_pos = Vector3i(x,0,z)
			gridmap.set_cell_item(grass_pos, 0)
			gridmap.set_cell_item(dirt_pos, 8)
	
	grid_generated.emit(preGenSize)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func addNav():
	var gridmap_item_list : PackedInt32Array = mesh_lib_src.get_item_list()
	for item in gridmap_item_list:
		var new_item_navigation_mesh : NavigationMesh = NavigationMesh.new()
		new_item_navigation_mesh.vertices = PackedVector3Array([
		Vector3(-1.0, 0.0, 1.0),
		Vector3(1.0, 0.0, 1.0),
		Vector3(1.0, 0.0, -1.0),
		Vector3(-1.0, 0.0, -1.0),])
		new_item_navigation_mesh.add_polygon(PackedInt32Array([0, 1, 2, 3]))
		mesh_lib_src.set_item_navigation_mesh(item, new_item_navigation_mesh)
	

		


func _on_camera_mount_ready_to_bake():
	navigation_region_3d.bake_navigation_mesh()
