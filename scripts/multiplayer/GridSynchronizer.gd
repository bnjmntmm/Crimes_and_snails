extends MultiplayerSynchronizer
@onready var grid_one = $".."

func _on_area_detection_body_exited(body):
	#print(body)
	if not is_inside_tree() or not multiplayer.has_multiplayer_peer() or not is_multiplayer_authority():
		return
	if body is Player:
		set_visibility_for(body.name.to_int(), false)
		#print(body.name + " left the area")
		#print(body.name + ":" + str(get_visibility_for(body.name.to_int())))
		pass

func _on_area_detection_body_entered(body):
	
	if not is_inside_tree() or not multiplayer.has_multiplayer_peer() or not is_multiplayer_authority():
		return
	if body is Player:
		#print(body.name   + "--" + str(body.name.to_int()))
		set_visibility_for(body.name.to_int(), true)
		#print(body.name + " entered the area")
		#print(body.name + ":" + str(get_visibility_for(body.name.to_int())))
		pass


