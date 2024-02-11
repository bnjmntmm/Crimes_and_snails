extends Control

@onready var music_percent_label = $TabContainer/Sound/VBoxContainer2/HBoxContainer/Music_percent_Label
@onready var alarm_percent_label = $TabContainer/Sound/VBoxContainer2/HBoxContainer2/Alarm_percent_Label
@onready var ambient_percent_label = $TabContainer/Sound/VBoxContainer2/HBoxContainer3/Ambient_percent_Label
@onready var main_percent_label = $TabContainer/Sound/VBoxContainer2/HBoxContainer4/Main_percent_Label

#### 
# DEFINE THE AUDIO_IDS FOR EACH LAYER
@onready var MAIN_BUS_ID = AudioServer.get_bus_index("Main")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("MUSIC")
@onready var ALARM_BUS_ID = AudioServer.get_bus_index("ALARM")
@onready var AMBIENT_BUS_ID = AudioServer.get_bus_index("AMBIENT")

###
var enabled_vsync = false



signal settings_closed


# Called when the node enters the scene tree for the first time.
func _ready():
	$TabContainer/Graphic/VBoxContainer2/HBoxContainer6/ShadowQuality.add_item("Fast",0)
	$TabContainer/Graphic/VBoxContainer2/HBoxContainer6/ShadowQuality.add_item("Good",1)
	$TabContainer/Graphic/VBoxContainer2/HBoxContainer6/ShadowQuality.add_item("Best",2)
	
	main_percent_label.text = str($TabContainer/Sound/VBoxContainer2/HBoxContainer4/MainSlider.value * 100) + "%"
	music_percent_label.text = str($TabContainer/Sound/VBoxContainer2/HBoxContainer/MusicSlider.value * 100) + "%"
	alarm_percent_label.text = str($TabContainer/Sound/VBoxContainer2/HBoxContainer2/AlarmSlider.value * 100) + "%"
	ambient_percent_label.text = str($TabContainer/Sound/VBoxContainer2/HBoxContainer3/AmbientSlider.value * 100) + "%"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_sdfgi_button_toggled(button_pressed):
	Settings.world_environement.environment.sdfgi_enabled = button_pressed


func _on_ssao_button_toggled(button_pressed):
	Settings.world_environement.environment.ssao_enabled = button_pressed


func _on_glow_button_toggled(button_pressed):
	Settings.world_environement.environment.glow_enabled = button_pressed

func _on_shadow_quality_item_selected(index):
	Settings.light.directional_shadow_mode = index


func _on_music_slider_value_changed(value):
	music_percent_label.text = str(value * 100) + "%"
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))

	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < 0.05)


func _on_alarm_slider_value_changed(value):
	alarm_percent_label.text = str(value * 100) + "%"
	AudioServer.set_bus_volume_db(ALARM_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(ALARM_BUS_ID, value < 0.05)


func _on_ambient_slider_value_changed(value):
	ambient_percent_label.text = str(value * 100) + "%"
	AudioServer.set_bus_volume_db(AMBIENT_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(AMBIENT_BUS_ID, value < 0.05)


func _on_main_slider_value_changed(value):
	main_percent_label.text = str(value * 100) + "%"
	AudioServer.set_bus_volume_db(MAIN_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MAIN_BUS_ID, value <0.05)




func _on_button_pressed():
	settings_closed.emit()
	self.visible = false


func _on_v_sync_button_toggled(button_pressed):
	enabled_vsync = !enabled_vsync
	if enabled_vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_display_option_button_item_selected(index):
	if index == 0:
		set_window_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif index == 1:
		set_window_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		

func set_window_mode(type):
	DisplayServer.window_set_mode(type)
