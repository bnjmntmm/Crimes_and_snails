extends Area3D
@onready var carpentry=$".."
var entered=false
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("left_mouse_down") and entered and carpentry.spawned:
		GameManager.opened_carpentry_menu = true


func _on_mouse_entered():
	print("entered")
	entered = true



func _on_mouse_exited():
	
	entered = false
