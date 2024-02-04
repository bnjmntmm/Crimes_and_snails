extends SubViewportContainer
@onready var house = $SubViewport/House


var viewportEntered = false
var rotating = false
var prev_mouse_pos
var next_mouse_pos

var start_rot

# Called when the node enters the scene tree for the first time.
func _ready():
	start_rot = house.rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left_mouse_down"):
		rotating = true
		prev_mouse_pos = get_viewport().get_mouse_position()
	if Input.is_action_just_released("left_mouse_down"):
		rotating = false
	if Input.is_action_just_pressed("right_mouse_down"):
		house.rotation = start_rot
	if rotating:
		next_mouse_pos = get_viewport().get_mouse_position()
		house.rotate_y((next_mouse_pos.x - prev_mouse_pos.x) * .3 * delta)
		house.rotate_x((next_mouse_pos.y - prev_mouse_pos.y) * .3 * delta)
		prev_mouse_pos = next_mouse_pos


func _on_mouse_entered():
	viewportEntered = true


func _on_mouse_exited():
	viewportEntered = false
