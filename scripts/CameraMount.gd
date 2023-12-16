extends Node3D

#lower sense slower camera/ higher sense faster camera e.g (2.0=fast, 0.5=slower) default value 0.1(in inspector)

@export var sense=1.0
@export var locked_cam:=false

var old_pos_mount : Vector3
@onready var selection_cube = $"../Grid/SelectionCube"
@onready var hud = $"../HUD"
@onready var water = $"../Water"


var grid_map : GridMap
var chunk_size = 64

var maxXGrid
var minXGrid
var maxZGrid
var minZGrid

signal newGridAdded(area_position)

var multi_mesh

# Called when the node enters the scene tree for the first time.
func _ready():
	grid_map = get_parent().get_node("Grid/BaseGrid")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewport_size = get_viewport().size
	var mouse_pos = get_viewport().get_mouse_position()
	if !locked_cam:
		if mouse_pos.x < 10:
			global_position -= transform.basis.x * sense
		elif mouse_pos.x > viewport_size.x - 10:
			global_position += transform.basis.x * sense

		if mouse_pos.y < 10:
			global_position -= transform.basis.z * sense
		elif mouse_pos.y > viewport_size.y - 10:
			global_position += transform.basis.z * sense

	

	if Input.is_action_just_released("mouse_wheel_up"):
		if $Camera.global_position.distance_to(global_position) > 15:
			$Camera.global_position -= $Camera.global_position * 0.1 * sense
	if Input.is_action_just_released("mouse_wheel_down"):
		if $Camera.global_position.distance_to(global_position) < 50:
			$Camera.global_position += $Camera.global_position * 0.1 * sense
	
	if Input.is_action_just_pressed("test") and GameManager.current_state != GameManager.State.BUY_LAND:
		old_pos_mount = $Camera.global_position
		locked_cam = true
		hud.visible = false
		$Camera.rotation = Vector3(deg_to_rad(-90),0,0)
		$Camera.position = Vector3(0,250,0)
		$Camera.set_fov(60)
		
		GameManager.current_state = GameManager.State.BUY_LAND
	elif Input.is_action_just_pressed("test") and GameManager.current_state == GameManager.State.BUY_LAND:
		GameManager.current_state = GameManager.State.PLAY
		locked_cam  = false
		hud.visible = true
		selection_cube.visible = false
		$Camera.rotation = Vector3(deg_to_rad(-60), 0,0)
		$Camera.global_position = old_pos_mount
		$Camera.set_fov(75)
	
	if GameManager.current_state == GameManager.State.BUY_LAND:
		selection_cube.visible = true
		var ray_origin = $Camera.project_ray_origin(get_viewport().get_mouse_position())
		var ray_direction = $Camera.project_ray_normal(get_viewport().get_mouse_position()).normalized()
		var ray_length = 1000
		var cursor_pos = ray_origin + ray_direction * ray_length
		var grid_size = 64
		var grid_cell_position = Vector3(floor(cursor_pos.x / grid_size) * grid_size, 0, floor(cursor_pos.z / grid_size) * grid_size)

		#AREA POSITION IS NOT ACCURATE @MIKA MACH MAL

		#var area_position = grid_cell_position - Vector3(grid_size / 2, 0, grid_size / 2)
		var area_position = grid_cell_position + Vector3(grid_size / 2,	 0, grid_size / 2)
		selection_cube.global_transform.origin = area_position
		
		
		if Input.is_action_just_released("left_mouse_down"):
			
			var can_place = can_place_chunk(area_position, grid_size)
			
			# TODO: NOT CORRECT POSITION AT THE MOMENT
			if can_place:
				for x in range(grid_size+1):
					for z in range(grid_size+1):
						var cell_position_grass = Vector3(area_position.x - grid_size / 2 + x, 1, area_position.z - grid_size / 2 + z)
						var cell_position_dirt = Vector3(area_position.x - grid_size / 2 + x, 0, area_position.z - grid_size / 2 + z)

						if grid_map.get_cell_item(cell_position_dirt) == -1 and grid_map.get_cell_item(cell_position_grass) == -1:
							grid_map.set_cell_item(cell_position_grass, 0)
							grid_map.set_cell_item(cell_position_dirt, 8)
							
						else:
							pass
				newGridAdded.emit(area_position)
	#			updateMinMaxValuesGrid(grid_map)
			else:
				print("cannot place new area. must be next to exisitng new area")
	
func can_place_chunk(area_position: Vector3, chunk_size: int) -> bool:
	var neighbor_positions = [
		Vector3(area_position.x + chunk_size, 0, area_position.z),
		Vector3(area_position.x - chunk_size, 0, area_position.z),
		Vector3(area_position.x, 0, area_position.z + chunk_size),
		Vector3(area_position.x, 0, area_position.z - chunk_size)
	]
	for neighbor_pos in neighbor_positions:
		if area_exists(neighbor_pos):
			if grid_map.get_cell_item(Vector3(area_position.x, 1,area_position.z)) == -1:
				return true
	return false
	
func area_exists(position: Vector3) -> bool:
	return grid_map.get_cell_item(position) != -1



## TODO:
# Mehrere Meshes -> Bäume etc
# Korrekte Location (also Höhe)
# Wenn Noise drin ist -> nicht in Luft Spawnbar
# Für die NPC's Angehbar?
	# -> Bereich dann invisible und nach zeit wieder visible?

func _on_new_grid_added(area_position):
	var instance_count = 5
	var bush_mesh = preload("res://assets/nature/bush1berries.glb")
	
	for i in range(instance_count):
		var bush_instance = bush_mesh.instantiate()
		bush_instance.add_to_group("food")
		get_parent().get_node("Grid/MultiMeshes/Bushes").add_child(bush_instance,true)
		randomize()
		bush_instance.transform.origin = area_position + Vector3(randi_range(-31, 31), 2, randi_range(-31,31))
		
	
#	multi_mesh = MultiMesh.new()
#	multi_mesh.transform_format = MultiMesh.TRANSFORM_3D
#	multi_mesh.mesh = preload("res://assets/nature/bush_mesh.res")
#	multi_mesh.instance_count = 5
#
#	var multi_mesh_instance = MultiMeshInstance3D.new()
#	multi_mesh_instance.multimesh = multi_mesh
#	get_parent().get_node("Grid/MultiMeshes").add_child(multi_mesh_instance)
#
#	for i in range(multi_mesh.instance_count):
#		randomize()
#		var transform = Transform3D()
#		transform = transform.scaled(Vector3(0.1,0.1,0.1))
#		transform.origin = area_position + Vector3(randi_range(-31, 31), 4, randi_range(-31,31))
#		multi_mesh.set_instance_transform(i,transform)

		


func _on_grid_grid_generated(size):	
	
	var instance_count = 50
	var bush_mesh = preload("res://assets/nature/bush1berries.glb")
	
	for i in range(instance_count):
		var bush_instance = bush_mesh.instantiate()
		bush_instance.add_to_group("food")
		get_parent().get_node("Grid/MultiMeshes/Bushes").add_child(bush_instance, true)
		randomize()
		bush_instance.transform.origin =  Vector3(randi_range(-size, size), 2, randi_range(-size,size))

	
	
#	multi_mesh = MultiMesh.new()
#	multi_mesh.transform_format = MultiMesh.TRANSFORM_3D
#	multi_mesh.mesh = preload("res://assets/nature/bush_mesh.res")
#	multi_mesh.instance_count = 50
#
#	var multi_mesh_instance = MultiMeshInstance3D.new()
#	multi_mesh_instance.multimesh = multi_mesh
#	get_parent().get_node("Grid/MultiMeshes").add_child(multi_mesh_instance)		
#	for i in range(multi_mesh.instance_count):
#		var meshLabel = Label3D.new()
#		meshLabel.billboard = true
#		meshLabel.font_size = 40
#		multi_mesh_instance.add_child(meshLabel)
#		randomize()
#		var transform = Transform3D()
#		transform = transform.scaled(Vector3(0.1,0.1,0.1))
#		transform.origin = Vector3(randi_range(-size, size), 4, randi_range(-size,size))
#		meshLabel.global_position = transform.origin + Vector3(0,2,0)
#		multi_mesh_instance.add_to_group("food")
#		multi_mesh.set_instance_transform(i,transform)
#		meshLabel.text = str(multi_mesh_instance.get_groups())

