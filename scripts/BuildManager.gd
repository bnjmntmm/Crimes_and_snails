extends Node3D

var House: PackedScene =ResourceLoader.load("res://scenes/building_scenes/house.tscn")
var Stock: PackedScene=ResourceLoader.load("res://scenes/building_scenes/stock.tscn")
var Terrarium: PackedScene = ResourceLoader.load("res://scenes/building_scenes/terrarium.tscn")
var able_to_build := true
var current_spawnable: StaticBody3D


func _physics_process(delta):
	if GameManager.current_state==GameManager.State.DESTROY:
		if is_instance_valid(current_spawnable):
			current_spawnable.queue_free()
			current_spawnable=null
		if Input.is_action_just_released("left_mouse_down"):
			var camera = get_viewport().get_camera_3d()
			var from = camera.project_ray_origin(get_viewport().get_mouse_position())
			var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 1000
			var space_state=get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create(from,to)
			var result = space_state.intersect_ray(query)
			if result.collider.is_in_group("building"):
				#result.collider.run_despawn()
				pass
	if Input.is_action_just_pressed("esc"):
		GameManager.current_state=GameManager.State.PLAY
		if current_spawnable!=null:
			current_spawnable.queue_free()
	if GameManager.current_state==GameManager.State.BUILD:
		var camera = get_viewport().get_camera_3d()
		var from = camera.project_ray_origin(get_viewport().get_mouse_position())
		var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 1000
		# Calculate where the mouse ray intersects the XZ plane (at height y of the transform origin).
		var cursor_pos = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, to)
		
		# Set the position of the current spawnable to the intersection point, with adjustments to x and z for snapping to a grid.
		current_spawnable.global_position = Vector3(round(cursor_pos.x), cursor_pos.y, round(cursor_pos.z)) + Vector3(0,1.5,0)
		current_spawnable.active_buildable_object=true
		
		if able_to_build:
			if Input.is_action_just_released("left_mouse_down"):
				var obj:=current_spawnable.duplicate()
				get_tree().root.add_child(obj)
				obj.active_buildable_object=false
				#obj.run_spawn()
				obj.spawned=true
				obj.set_disabled(false)
				
				obj.global_position=current_spawnable.global_position
		if Input.is_action_just_released("middle_mouse_button"):
			current_spawnable.rotation_degrees+=Vector3(0,90,0)
		
func spawn_house():
	spawn_object(House)
func spawn_stock():
	spawn_object(Stock)
func spawn_terrarium():
	spawn_object(Terrarium)
	
	
func spawn_object(obj):
	if current_spawnable!=null:
		current_spawnable.queue_free()
	current_spawnable=obj.instantiate()
	current_spawnable.set_disabled(true)
	get_tree().root.add_child(current_spawnable)
	GameManager.current_state=GameManager.State.BUILD
