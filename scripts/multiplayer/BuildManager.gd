extends Node3D

@onready var House: PackedScene=ResourceLoader.load("res://assets/buildings/house.tscn")

var able_to_build:=true
var current_spawnable : StaticBody3D


func _physics_process(delta):
	if Input.is_action_just_pressed("esc") and GameManager.current_state != GameManager.State.POV_MODE:
		GameManager.current_state = GameManager.State.PLAY
		if current_spawnable != null:
			current_spawnable.queue_free()
	if GameManager.current_state==GameManager.State.BUILDING and get_window().has_focus():
		var camera = get_viewport().get_camera_3d()
		var from = camera.project_ray_origin(get_viewport().get_mouse_position())
		var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 1000
		var cursor_pos = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, to)
		current_spawnable.global_position=Vector3(round(cursor_pos.x), cursor_pos.y, round(cursor_pos.z))
		if able_to_build:
			if Input.is_action_just_released("LeftMouseDown"):
				var obj:=current_spawnable.duplicate()
				get_tree().root.get_node("World").add_child(obj)
				#obj.spawned = true
				obj.set_disabled(false)
				obj.global_position=current_spawnable.global_position
				
			if Input.is_action_just_released("MiddleMouseButton"):
				current_spawnable.rotation_degrees+=Vector3(0,90,0)
				
				
				
func spawn_house():
	spawn_object(House)
	
func spawn_object(obj):
	if current_spawnable!=null:
		current_spawnable.queue_free()
	current_spawnable=obj.instantiate()
	current_spawnable.set_disabled(true)
	get_tree().root.add_child(current_spawnable)
	GameManager.current_state=GameManager.State.BUILDING


		
