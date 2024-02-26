extends Node3D

#lower sense slower camera/ higher sense faster camera e.g (2.0=fast, 0.5=slower) default value 0.1(in inspector)

@export var sense=1.0
@export var locked_cam:=false
@export var min_zoom=0.5
@export var max_zoom=3
@export var zoom_speed=0.08
var zoom=1.5
@onready var navigation_region_3d = $"../Grid/NavigationRegion3D"

@export var generate_bushes_and_trees_range = 28

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

var multi_mesh
var buy_label : Label3D

var buyingNewLand = false


# Neighbour Areas
@onready var rightArea = $"../Grid/SelectionCube/NeighbourCheck/Right"
@onready var topArea = $"../Grid/SelectionCube/NeighbourCheck/Top"
@onready var leftArea = $"../Grid/SelectionCube/NeighbourCheck/Left"
@onready var bottomArea = $"../Grid/SelectionCube/NeighbourCheck/Bottom"

#Main Area
@onready var main_area = $"../Grid/SelectionCube/Area3D"

@onready var play_area = $"../Grid/PlayArea"


var plane_prefab = preload("res://scenes/plane_adding/plane.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	#grid_map = get_parent().get_node("Grid/BaseGrid")
	buy_label = Label3D.new()
	buy_label.font_size = 4000
	buy_label.outline_size = 800
	buy_label.modulate = Color(255, 255, 255,1)
	buy_label.billboard = 1
	buy_label.position = Vector3(0,4,0)
	selection_cube.add_child(buy_label)
	buy_label.visible = false
	GameManager.main_node = get_tree().root.get_child(3)

	
	
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
		GameManager.wood = GameManager.wood + 10
		GameManager.food = GameManager.food + 10

	if Input.is_action_just_released("mouse_wheel_up"):
		if !GameManager.opened_lab_menu or !GameManager.opened_npc_menu or !GameManager.opened_house_menu:
			zoom-=zoom_speed
#		if $Camera.global_position.distance_to(global_position) > 15:
#			$Camera.global_position -= $Camera.global_position * 0.1 * sense

		
		
	if Input.is_action_just_released("mouse_wheel_down"):
		if !GameManager.opened_lab_menu or !GameManager.opened_npc_menu or !GameManager.opened_house_menu:
			zoom+=zoom_speed
	zoom=clamp(zoom,min_zoom,max_zoom)
	scale=lerp(scale,Vector3.ONE*zoom,zoom_speed)
#		if $Camera.global_position.distance_to(global_position) < 50:
#			$Camera.global_position += $Camera.global_position * 0.1 * sense

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
			var raycast_position = raycast_result.position
			var snapped_x = snapped(raycast_position.x, grid_size)
			var snapped_z = snapped(raycast_position.z, grid_size)
			grid_cell_pos = Vector3(snapped_x,1,snapped_z)
			selection_cube.position = grid_cell_pos
			
		if can_place_plane():
			buy_label.visible = true
		else:
			buy_label.visible = false
		buy_label.text = str(GameManager.current_price_for_land)
		if Input.is_action_just_released("left_mouse_down"):
			if typeof(grid_cell_pos) == TYPE_VECTOR3:
				if GameManager.current_price_for_land < GameManager.snails:
					if can_place_plane():
						var new_plane = plane_prefab.instantiate()
						new_plane.position = grid_cell_pos + Vector3(0,0.5,0)
						play_area.add_child(new_plane,true)
						GameManager.snails = GameManager.snails - GameManager.current_price_for_land
						newGridAdded.emit(new_plane)


func can_place_chunk(area_position: Vector3, chunk_size: int) -> bool:
	var area3d_check = Area3D.new()
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

func can_place_plane():
	var rightAreaOverlaps = []
	var topAreaOverlaps = []
	var leftAreaOverlaps = []
	var bottomAreaOverlaps = []
	var selectionOverlaps = []
	
	
	if rightArea.has_overlapping_bodies():
		rightAreaOverlaps = rightArea.get_overlapping_bodies()
	if leftArea.has_overlapping_bodies():
		leftAreaOverlaps = leftArea.get_overlapping_bodies()
	if topArea.has_overlapping_bodies():
		topAreaOverlaps = topArea.get_overlapping_bodies()
	if bottomArea.has_overlapping_bodies():
		bottomAreaOverlaps = bottomArea.get_overlapping_bodies()
	if main_area.has_overlapping_bodies():
		selectionOverlaps = main_area.get_overlapping_bodies()
	if selectionOverlaps == []:
		if rightAreaOverlaps != [] or leftAreaOverlaps != [] or topAreaOverlaps != [] or bottomAreaOverlaps != []:
			return true
	return false

	


## TODO:
# Mehrere Meshes -> Bäume etc
# Korrekte Location (also Höhe)
# Wenn Noise drin ist -> nicht in Luft Spawnbar
# Für die NPC's Angehbar?
	# -> Bereich dann invisible und nach zeit wieder visible?

func _on_new_grid_added(body : StaticBody3D):
	var instance_count = 5
	for i in range(instance_count):
		var bush_instance = bush_mesh.instantiate()
		bush_instance.add_to_group("food")
		get_parent().get_node("Grid/PlayArea").get_node(str(body)).get_child(0).get_child(1).call_thread_safe("add_child", bush_instance,true)
		randomize()
		var random_vec_bush =  Vector3(randi_range(-generate_bushes_and_trees_range,generate_bushes_and_trees_range),0,randi_range(-generate_bushes_and_trees_range,generate_bushes_and_trees_range))
		bush_instance.global_position =  body.global_position + random_vec_bush
		GameManager.bush_array.append(bush_instance)
		
		var tree_instance : StaticBody3D = tree_mesh.instantiate()
		tree_instance.add_to_group("wood")
		get_parent().get_node("Grid/PlayArea").get_node(str(body)).get_child(0).get_child(1).call_thread_safe("add_child", tree_instance,true)
		var random_vec_tree =  Vector3(randi_range(-generate_bushes_and_trees_range,generate_bushes_and_trees_range),0,randi_range(-generate_bushes_and_trees_range,generate_bushes_and_trees_range))
		tree_instance.global_position =  body.global_position + random_vec_tree
		GameManager.tree_array.append(tree_instance)
	#ready_to_bake.emit() ##this mofo lags :D
	#call_deferred("bake_nav",body)
	body.bake_nav()
	
	#Exponential Growth
	GameManager.numberOfBoughtLands += 1
	GameManager.current_price_for_land = ceilf(GameManager.BasePrice * pow(1.3,GameManager.numberOfBoughtLands))
	print(GameManager.current_price_for_land)

	


func _on_grid_grid_generated(body: StaticBody3D):	
	
	var instance_count = 5
	
	for i in range(instance_count):
		var bush_instance = bush_mesh.instantiate()
		bush_instance.add_to_group("food")
		get_parent().get_node("Grid/PlayArea").get_node(str(body)).get_child(0).get_child(1).call_thread_safe("add_child", bush_instance,true)
		randomize()
		var random_vec_bush =  Vector3(randi_range(-generate_bushes_and_trees_range,generate_bushes_and_trees_range),0,randi_range(-generate_bushes_and_trees_range,generate_bushes_and_trees_range))
		bush_instance.global_position =  body.global_position + random_vec_bush
		GameManager.bush_array.append(bush_instance)
		
		var tree_instance : StaticBody3D = tree_mesh.instantiate()
		tree_instance.add_to_group("wood")
		
		var tree_variants = tree_instance.find_child("tree_variants")
		var tree_variant = tree_variants.get_children().pick_random()
		tree_variant.visible = true
		
		get_parent().get_node("Grid/PlayArea").get_node(str(body)).get_child(0).get_child(1).call_thread_safe("add_child", tree_instance,true)
		var random_vec_tree =  Vector3(randi_range(-generate_bushes_and_trees_range,generate_bushes_and_trees_range),0,randi_range(-generate_bushes_and_trees_range,generate_bushes_and_trees_range))
		tree_instance.global_position =  body.global_position + random_vec_tree
		GameManager.tree_array.append(tree_instance)
	GameManager.first_area_generated = true
	#ready_to_bake.emit()
	body.bake_nav()

func switchMonitoringForBuyLand(buyingNewLand : bool):
	rightArea.monitorable = buyingNewLand
	leftArea.monitorable = buyingNewLand
	topArea.monitorable = buyingNewLand
	bottomArea.monitorable = buyingNewLand


func _on_hud_switch_to_buy_land_camera():
	buyingNewLand = !buyingNewLand
	if buyingNewLand:
		old_pos_mount = $Camera.position
		locked_cam = true
		hud.visible = false
		$Camera.rotation = Vector3(deg_to_rad(-90),0,0)
		$Camera.position = Vector3(0,250,0)
		$Camera.set_fov(60)
		switchMonitoringForBuyLand(buyingNewLand)
	else:
		GameManager.current_state = GameManager.State.PLAY
		buy_label.visible = false
		locked_cam  = false
		hud.visible = true
		selection_cube.visible = false
		$Camera.rotation = Vector3(deg_to_rad(-45), 0,0)
		$Camera.position = Vector3(0, 20, 0)
		$Camera.set_fov(75)
		switchMonitoringForBuyLand(buyingNewLand)
	
