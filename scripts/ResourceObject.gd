extends StaticBody3D
@onready var label_3d = $Label3D
@onready var bush_mesh = $bush1berries



var spots_for_workers:=1
var current_worker_amount:=0
var resource_amount_generated:=5
var max_times_farmable:=1
var current_times_farmed:=0
var is_farmable:=true

func _ready():
	pass
func _on_farmed():
	current_times_farmed+=1
	#print("farmed" +  str(self))
func _on_max_farmed_reached():
	label_3d.show()
	self.is_farmable=false
	bush_mesh.hide()
	self.current_worker_amount=0
	self.current_times_farmed=0
	$RespawnTimer.start()

func _process(delta):
	
	label_3d.text="Respawn in: " + str($RespawnTimer.time_left).substr(0,2)
	if current_times_farmed==max_times_farmable and is_farmable:
		_on_max_farmed_reached()
		
	
			

	


func _on_respawn_timer_timeout():
	self.is_farmable=true
	bush_mesh.show()
	label_3d.hide()