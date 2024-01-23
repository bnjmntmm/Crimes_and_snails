extends Node3D

var House: PackedScene =ResourceLoader.load("res://scenes/building_scenes/house.tscn")
var Stock: PackedScene=ResourceLoader.load("res://scenes/building_scenes/stock.tscn")
var Terrarium: PackedScene = ResourceLoader.load("res://scenes/building_scenes/terrarium.tscn")
var Incubator: PackedScene = ResourceLoader.load("res://scenes/building_scenes/incubator.tscn")
var able_to_build := true
var current_spawnable: StaticBody3D

var currentlyMovingObject
var currentlyMoving = false

#Random Events Area
signal houseSceneAdded(houseObj)
signal houseSceneRemoved(houseObj)

class HouseObj:
	var staticbody : StaticBody3D = null
	var fire_scene = null
	var tornado_scene = null
	var isBurning : bool = false
	var isTornado : bool = false
	var isDestroyed: bool = false


func _physics_process(delta):
	if GameManager.current_state==GameManager.State.DESTROY:
		if current_spawnable!=null:
			current_spawnable.queue_free()
			current_spawnable=null
		if currentlyMoving:
			currentlyMoving = false
			currentlyMovingObject = null
		if Input.is_action_just_released("left_mouse_down"):
			var camera = get_viewport().get_camera_3d()
			var from = camera.project_ray_origin(get_viewport().get_mouse_position())
			var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 1000
			var space_state=get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create(from,to)
			var result = space_state.intersect_ray(query)
			if result.collider.is_in_group("building") or result.collider.is_in_group("stock"):
				#result.collider.run_despawn()
				result.collider.queue_free()
				if result.collider.name.contains("House"):
					GameManager.houses_built-=1
					
				houseSceneRemoved.emit(result.collider)
	if Input.is_action_just_pressed("esc") and not GameManager.current_state == GameManager.State.POV_MODE:
		GameManager.opened_house_menu = false
		GameManager.current_state=GameManager.State.PLAY
		if current_spawnable!=null:
			current_spawnable.queue_free()
		if currentlyMoving:
			currentlyMoving = false
			currentlyMovingObject = null
	if GameManager.current_state==GameManager.State.BUILD:
		var camera = get_viewport().get_camera_3d()
		var from = camera.project_ray_origin(get_viewport().get_mouse_position())
		var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 10000
		# Calculate where the mouse ray intersects the XZ plane (at height y of the transform origin).
		var cursor_pos = Plane(Vector3.UP, 1.5).intersects_ray(from, to)
		if typeof(cursor_pos)== TYPE_VECTOR3:
		# Set the position of the current spawnable to the intersection point, with adjustments to x and z for snapping to a grid.
			current_spawnable.global_position = Vector3(round(cursor_pos.x), cursor_pos.y, round(cursor_pos.z)) 
			current_spawnable.active_buildable_object=true
			
			if able_to_build:
				if Input.is_action_just_released("left_mouse_down"):	
					var obj:=current_spawnable.duplicate()
					
					get_tree().root.get_node("main").get_node("Grid").get_node("NavigationRegion3D").add_child(obj,true)
					obj.active_buildable_object=false
					#obj.run_spawn()
					obj.spawned=true
					obj.set_disabled(false)
					houseSceneAdded.emit(obj)
					
					obj.global_position=current_spawnable.global_position
					if obj.name == "Stock":
						GameManager.stock_array.append(obj)
					if obj.name.contains("House"):
						GameManager.houses_built+=1
					current_spawnable.remove_foliage()
					get_tree().root.get_node("main").get_node("Grid").get_node("NavigationRegion3D").bake_navigation_mesh()
					
					
			if Input.is_action_just_released("middle_mouse_button"):
				current_spawnable.rotation_degrees+=Vector3(0,90,0)
	if GameManager.current_state==GameManager.State.MOVE_HOUSE:
		var camera = get_viewport().get_camera_3d()
		var from = camera.project_ray_origin(get_viewport().get_mouse_position())
		var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 10000
		var space_state=get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from,to)
		if currentlyMovingObject !=null:
			query.set_exclude([currentlyMovingObject.get_rid()])
		else:
			query.set_exclude([])
		var result = space_state.intersect_ray(query)
		var cursor_pos = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, to)
		
				
		if currentlyMoving:
			currentlyMovingObject.global_position = Vector3(round(cursor_pos.x), cursor_pos.y, round(cursor_pos.z)) + Vector3(0,1.5,0)
			if Input.is_action_just_released("middle_mouse_button"):
				currentlyMovingObject.rotation_degrees+=Vector3(0,90,0)
			
			if Input.is_action_just_pressed("left_mouse_down") and currentlyMoving and currentlyMovingObject != null:
				currentlyMovingObject.remove_foliage()
				currentlyMoving = false
				currentlyMovingObject = null
			
		if result.size() > 0 and typeof(cursor_pos)== TYPE_VECTOR3:
			if result.collider.is_in_group("building") or result.collider.is_in_group("stock"):
				if Input.is_action_just_pressed("left_mouse_down") and !currentlyMoving:
					currentlyMovingObject = result.collider
					currentlyMoving = true

		
				
		
		
func spawn_house():
	
	
	spawn_object(House)
	
	
func spawn_stock():
	spawn_object(Stock)
func spawn_terrarium():
	spawn_object(Terrarium)
	
func spawn_incubator():
	spawn_object(Incubator)
	
func spawn_object(obj):
	if current_spawnable!=null:
		current_spawnable.queue_free()
	current_spawnable=obj.instantiate()
	current_spawnable.set_disabled(true)
	get_tree().root.add_child(current_spawnable)
	GameManager.current_state=GameManager.State.BUILD
