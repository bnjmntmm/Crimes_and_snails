extends Control
@onready var status = $Panel/status


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_stop_button_button_down():
	GameManager.carpentry_running=false
	
	status.text="stopped"


func _on_start_button_button_down():
	GameManager.carpentry_running=true
	status.text="running"
	



	


func _on_button_button_down():
	GameManager.opened_carpentry_menu=false
	visible=false
