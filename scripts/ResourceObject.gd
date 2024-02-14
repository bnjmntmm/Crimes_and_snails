extends StaticBody3D
@onready var label_3d = $Label3D
@onready var audio_stream_player = $AudioStreamPlayer3D



@export var mesh : Node3D
@export var spots_for_workers:=1
@export var resource_amount_generated:=5
@export var max_times_farmable:=1

var current_worker_amount:=0
var current_times_farmed:=0
var is_farmable:=true



func _on_farmed():
	audio_stream_player.play()
	current_times_farmed+=1
	#print("farmed" +  str(self))
func _on_max_farmed_reached():
	#label_3d.show()
	self.is_farmable=false
	label_3d.text="Respawn in: " + str($RespawnTimer.time_left).substr(0,2)
	mesh.hide()
	self.current_worker_amount=0
	self.current_times_farmed=0
	$RespawnTimer.start()

func _process(delta):
	if current_worker_amount>=spots_for_workers:
		self.is_farmable=false
	if current_times_farmed==max_times_farmable:
		_on_max_farmed_reached() 
		
	
			

	


func _on_respawn_timer_timeout():
	self.is_farmable=true
	mesh.show()
	#label_3d.hide()
