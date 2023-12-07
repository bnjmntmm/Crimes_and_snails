extends Control


const loading_scene_path = "res://scenes/loading_screen.tscn"




func _on_start_button_pressed():
	get_tree().change_scene_to_file(loading_scene_path)


func _on_quit_button_pressed():
	get_tree().quit()
