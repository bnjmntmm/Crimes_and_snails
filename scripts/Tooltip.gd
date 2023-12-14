extends Control


var current_icon

func _make_custom_tooltip(for_text):
	var tooltip = preload("res://scenes/game_scenes/tooltip.tscn").instantiate()
	tooltip.get_node("description").text = for_text
	tooltip.get_node("current_icon").texture = current_icon
	return tooltip




func _on_mouse_entered_snails():
	current_icon = preload("res://assets/textures/HUD/Snail.PNG")


func _on_mouse_entered_happiness():
	current_icon = preload("res://assets/textures/HUD/Happiness.png")


func _on_mouse_entered_food():
	current_icon = preload("res://assets/textures/HUD/Food.PNG")


func _on_mouse_entered_wood():
	current_icon = preload("res://assets/textures/HUD/Wood.PNG")


func _on_mouse_entered_planks():
	current_icon = preload("res://assets/textures/HUD/Wood Planks.PNG")
