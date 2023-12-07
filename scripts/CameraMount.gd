extends Node3D

#lower sense slower camera/ higher sense faster camera e.g (2.0=fast, 0.5=slower) default value 0.1(in inspector)

@export var sense=1.0
@export var locked_cam:=false

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
