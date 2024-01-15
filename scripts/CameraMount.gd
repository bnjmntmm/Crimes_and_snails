extends Node3D

#lower sense slower camera/ higher sense faster camera e.g (2.0=fast, 0.5=slower) default value 0.1(in inspector)

@export var sense=1.0
@export var locked_cam:=false
@export var min_zoom=0.5
@export var max_zoom=3
@export var zoom_speed=0.08
var zoom=1.5
@onready var navigation_region_3d = $"../Grid/NavigationRegion3D"

@onready var bought_grid_nav_plane=ResourceLoader.load("res://scenes/game_scenes/bought_grid_nav_plane.tscn")

var old_pos_mount : Vector3
@onready var selection_cube = $"../Grid/SelectionCube"

@onready var hud = $"../HUD"
@onready var water = $"../Water"

var bush_mesh = ResourceLoader.load("res://scenes/game_scenes/bush.tscn")
var tree_mesh = ResourceLoader.load("res://scenes/game_scenes/tree.tscn")


var grid_map : GridMap
var chunk_size = 64

var maxXGrid
var minXGrid
var maxZGrid
var minZGrid

signal newGridAdded(area_position)
signal ready_to_bake

var multi_mesh
var buy_label : Label3D

# Called when the node enters the scene tree for the first time.
func _ready():
	grid_map = get_parent().get_node("Grid/BaseGrid")
	buy_label = Label3D.new()
	buy_label.font_size = 2000
	buy_label.outline_size = 800
	buy_label.modulate = Color(255, 255, 255,1)
	buy_label.billboard = 1
	buy_label.position = Vector3(0,4,0)
	selection_cube.add_child(buy_label)
	buy_label.visible = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var viewport_size = Vector2(viewport_width,viewport_height)
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

	if Input.is_action_just_pressed("add_snails_command"):
		GameManager.snails = GameManager.snails +10

	if Input.is_action_just_released("mouse_wheel_up"):
		zoom-=zoom_speed
#		if $Camera.global_position.distance_to(global_position) > 15:
#			$Camera.global_position -= $Camera.global_position * 0.1 * sense

		
		
	if Input.is_action_just_released("mouse_wheel_down"):
		zoom+=zoom_speed
	zoom=clamp(zoom,min_zoom,max_zoom)
	scale=lerp(scale,Vector3.ONE*zoom,zoom_speed)
#		if $Camera.global_position.distance_to(global_position) < 50:
#			$Camera.global_position += $Camera.global_position * 0.1 * sense
	
	if Input.is_action_just_pressed("buy_land") and GameManager.current_state != GameManager.State.BUY_LAND:
		old_pos_mount = $Camera.position
		locked_cam = true
		hud.visible = false
		$Camera.rotation = Vector3(deg_to_rad(-90),0,0)
		$Camera.position = Vector3(0,250,0)
		$Camera.set_fov(60)
		
		GameManager.current_state = GameManager.State.BUY_LAND
	elif Input.is_action_just_pressed("buy_land") and GameManager.current_state == GameManager.State.BUY_LAND:
		GameManager.current_state = GameManager.State.PLAY
		buy_label.visible = false
		locked_cam  = false
		hud.visible = true
		selection_cube.visible = false
		$Camera.rotation = Vector3(deg_to_rad(-45), 0,0)
		$Camera.position = old_pos_mount
		$Camera.set_fov(75)
	
	if GameManager.current_state == GameManager.State.BUY_LAND:
		selection_cube.visible = true
		var ray_length = 1000
		var grid_size = 64
	
		var from = $Camera.project_ray_origin(mouse_pos)
		var to = from + $Camera.project_ray_normal(mouse_pos) * ray_length
		var space = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.from = from
		ray_query.to = to
		ray_query.collide_with_areas = true
		ray_query.collide_with_bodies = true
	
		var raycast_result = space.intersect_ray(ray_query)
		var grid_cell_pos : Vector3
		if raycast_result.size() > 0:
			grid_cell_pos = Vector3(floor(raycast_result.position.x / grid_size) * grid_size, 0, floor(raycast_result.position.z / grid_size) * grid_size)  + Vector3(grid_size / 2,	 0, grid_size / 2)
			selection_cube.global_transform.origin = grid_cell_pos
		
		if can_place_chunk(grid_cell_pos,grid_size):
			buy_label.visible = true
		else:
			buy_label.visible = false
		buy_label.text = str(GameManager.current_price_for_land)
		
		if Input.is_action_just_released("left_mouse_down"):
			
			if typeof(grid_cell_pos)== TYPE_VECTOR3:
				if GameManager.current_price_for_land < GameManager.snails:
					var can_place = can_place_chunk(grid_cell_pos, grid_size)
					if can_place:
						for x in range(grid_size):
							for z in range(grid_size):
								var cell_position_grass = Vector3(grid_cell_pos.x - grid_size / 2 + x, 1, grid_cell_pos.z - grid_size / 2 + z)
								var cell_position_dirt = Vector3(grid_cell_pos.x - grid_size / 2 + x, 0, grid_cell_pos.z - grid_size / 2 + z)

								if grid_map.get_cell_item(cell_position_dirt) == -1 and grid_map.get_cell_item(cell_position_grass) == -1:
									grid_map.set_cell_item(cell_position_grass, 0)
									grid_map.set_cell_item(cell_position_dirt, 8)
									
								else:
									pass
						var new_area_nav_plane=bought_grid_nav_plane.instantiate()
						navigation_region_3d.add_child(new_area_nav_plane,true)
						new_area_nav_plane.global_position=grid_cell_pos
						new_area_nav_plane.global_position+=Vector3(0,1,0)
						GameManager.snails = GameManager.snails - GameManager.current_price_for_land
						newGridAdded.emit(grid_cell_pos)
						
			#			updateMinMaxValuesGrid(grid_map)
					else:
						print("cannot place new area. must be next to exisiting new area")
	
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
	for i in range(instance_count):
		var bush_instance = bush_mesh.instantiate()
		bush_instance.add_to_group("food")
		get_parent().get_node("Grid/NavigationRegion3D/MultiMeshes/Bushes").add_child(bush_instance,true)
		randomize()
		bush_instance.transform.origin = area_position + Vector3(randi_range(-31, 31), 1.5, randi_range(-31,31))
		GameManager.bush_array.append(bush_instance)
		
		var tree_instance = tree_mesh.instantiate()
		tree_instance.add_to_group("wood")
		get_parent().get_node("Grid/NavigationRegion3D/MultiMeshes/Trees").add_child(tree_instance,true)
		tree_instance.transform.origin = area_position + Vector3(randi_range(-31, 31), 1.5, randi_range(-31,31))
		GameManager.tree_array.append(tree_instance)
	ready_to_bake.emit()

	
	
	#Exponential Growth
	GameManager.numberOfBoughtLands += 1
	GameManager.current_price_for_land = ceilf(GameManager.BasePrice * pow(1.3,GameManager.numberOfBoughtLands))
	print(GameManager.current_price_for_land)

	


func _on_grid_grid_generated(size):	
	
	var instance_count = 50
	
	for i in range(instance_count):
		var bush_instance = bush_mesh.instantiate()
		bush_instance.add_to_group("food")
		get_parent().get_node("Grid/NavigationRegion3D/MultiMeshes/Bushes").add_child(bush_instance, true)
		randomize()
		bush_instance.transform.origin =  Vector3(randi_range(-size, size), 1.5, randi_range(-size,size))
		GameManager.bush_array.append(bush_instance)
		
		var tree_instance = tree_mesh.instantiate()
		tree_instance.add_to_group("wood")
		get_parent().get_node("Grid/NavigationRegion3D/MultiMeshes/Trees").add_child(tree_instance,true)
		tree_instance.transform.origin =  Vector3(randi_range(-size, size), 1.5, randi_range(-size,size))
		GameManager.tree_array.append(tree_instance)
	GameManager.first_area_generated = true
	ready_to_bake.emit()
	
