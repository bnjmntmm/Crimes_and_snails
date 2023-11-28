class_name Player extends CharacterBody3D


@onready var camera = $CameraMount/Camera3D
@onready var camera_mount = $CameraMount
@onready var house_button:Button=get_tree().root.get_node("World").get_node("Control/HBoxContainer/House")



var gold = 0
var own_position
@export var sense=1.0
@export var locked_cam:=false
var focused_window
const SPEED = 10.0
const JUMP_VELOCITY = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 20.0

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	house_button.button_down.connect(_on_house_button_down)
	
	#print(hud_pos_value)
	if not is_multiplayer_authority(): return
	
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = true
	
	
func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	
	
	

func _physics_process(delta):
	
	
		
	if not is_multiplayer_authority(): return
	
	# Add the gravity.
#	if not is_on_floor():
#		velocity.y -= gravity * delta

	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	
	var viewport_size = get_viewport().size

	var mouse_pos = get_viewport().get_mouse_position()
	
	if !locked_cam and self.is_multiplayer_authority() and get_window().has_focus():
		if Input.is_action_just_released("mouse_wheel_up"):
			if camera.position.distance_to(camera_mount.position) > 25:
				camera.position -= camera.position * 0.1 * sense
		if Input.is_action_just_released("mouse_wheel_down"):
			if camera.position.distance_to(camera_mount.position) < 50:
				camera.position += camera.position * 0.1 * sense
		if mouse_pos.x < 10:
			global_position -= transform.basis.x * sense
		elif mouse_pos.x > viewport_size.x - 10:
			global_position += transform.basis.x * sense

		if mouse_pos.y < 10:
			global_position -= transform.basis.z * sense
		elif mouse_pos.y > viewport_size.y - 10:
			global_position += transform.basis.z * sense
		
#	if Input.is_action_just_pressed("spawnGold"):
#		GameManager.Players[multiplayer.get_unique_id()].gold +=1

		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
#	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
#	if direction:
#		velocity.x = direction.x * SPEED
#		velocity.z = direction.z * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#		velocity.z = move_toward(velocity.z, 0, SPEED)
#	move_and_slide()
	
func _on_house_button_down():
	if is_multiplayer_authority():
		BuildManager.spawn_house()
