extends Control

var current_building

func _make_custom_tooltip(for_text):
	var tooltip = preload("res://scenes/game_scenes/tooltip_buildings.tscn").instantiate()
	tooltip.get_node("description").text = for_text
	tooltip.get_node("current_building").texture = current_building
	return tooltip


func _on_mouse_entered_house():
	current_building = preload("res://assets/textures/building_images/house_image.png")

