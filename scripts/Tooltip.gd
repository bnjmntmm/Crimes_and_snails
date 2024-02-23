extends Control


var current_icon

var snail_icon = preload("res://assets/textures/HUD/snail.png")
var happines_icon = preload("res://assets/textures/HUD/Happiness.png")
var food_icon = preload("res://assets/textures/HUD/Food.PNG")
var wood_icon = preload("res://assets/textures/HUD/Wood.PNG")
var planks_icon = preload("res://assets/textures/HUD/Wood_planks.PNG")

var happinessText: String = "Happiness:
Happiness shows how satisfied the villagers are with the amount of food.
Currently it is: " + str(GameManager.inspiration)





func _make_custom_tooltip(for_text):
	var tooltip = preload("res://scenes/game_scenes/tooltip.tscn").instantiate()
	if current_icon == happines_icon:
		tooltip.get_node("description").text = happinessText
	else:
		tooltip.get_node("description").text = for_text
	tooltip.get_node("current_icon").texture = current_icon
	
	tooltip.custom_minimum_size = Vector2(300,320)
	return tooltip




func _on_mouse_entered_snails():
	current_icon = snail_icon


func _on_mouse_entered_happiness():
	current_icon = happines_icon


func _on_mouse_entered_food():
	current_icon = food_icon


func _on_mouse_entered_wood():
	current_icon = wood_icon


func _on_mouse_entered_planks():
	current_icon = planks_icon

