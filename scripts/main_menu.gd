extends Control

@export var loading_scene : PackedScene



@onready var settings_button = $Panel/VBoxContainer2/Panel2/Panel/HBoxContainer3/SettingsButton


func _ready():
	Settings.world_environement = $WorldEnvironment


func _on_start_button_pressed():
	get_tree().change_scene_to_packed(loading_scene)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_settings_button_pressed():
	$Panel/Settings.visible = !$Panel/Settings.visible
