extends Control


const loading_scene_path = "res://scenes/game_scenes/loading_screen.tscn"

@onready var settings_button = $Panel/VBoxContainer2/HBoxContainer3/SettingsButton



func _on_start_button_pressed():
	get_tree().change_scene_to_file(loading_scene_path)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_settings_button_pressed():
	$Panel/Settings.visible = !$Panel/Settings.visible
