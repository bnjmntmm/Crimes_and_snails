extends Node3D

#lower sense slower camera/ higher sense faster camera e.g (2.0=fast, 0.5=slower) default value 0.1(in inspector)

@export var sense=1.0
@export var locked_cam:=false

var old_pos_mount : Vector3
@onready var selection_cube = $"../Grid/SelectionCube"


var grid_map : GridMap


# Called when the node enters the scene tree for the first time.
func _ready():
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
		$Camera.rotation = Vector3(deg_to_rad(-90),0,0)
		$Camera.position = Vector3(0,250,0)
		$Camera.set_fov(60)
		grid_map = get_parent().find_child("Grid").get_child(1)
		GameManager.current_state = GameManager.State.BUY_LAND
	elif Input.is_action_just_pressed("test") and GameManager.current_state == GameManager.State.BUY_LAND:
		GameManager.current_state = GameManager.State.PLAY
		locked_cam  = false
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
		var area_position = grid_cell_position + Vector3(grid_size / 2, 0, grid_size / 2)
		selection_cube.global_transform.origin = area_position
		if Input.is_action_just_released("left_mouse_down"):
			# TODO: NOT CORRECT POSITION AT THE MOMENT ONLY THE MIDDLE IS SPAWNED
			for x in range(grid_size):
				for z in range(grid_size):
					var cell_position_grass = Vector3(area_position.x - grid_size / 2 + x, 1, area_position.z - grid_size / 2 + z)
					var cell_position_dirt = Vector3(area_position.x - grid_size / 2 + x, 0, area_position.z - grid_size / 2 + z)
					grid_map.set_cell_item(cell_position_grass, 0)
					grid_map.set_cell_item(cell_position_dirt, 8)
					
