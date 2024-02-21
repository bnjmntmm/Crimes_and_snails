extends Control

var current_building

var house_img = preload("res://assets/textures/building_images/house_image.png")
var stock_img = preload("res://assets/textures/building_images/stock_image.png")
var carpentry_img = preload("res://assets/textures/building_images/carpentry_image.png")
var bakery_img = preload("res://assets/textures/building_images/bakery_image.png")
var incub_img = preload("res://assets/textures/building_images/incubator_image.png")
var labor_img = preload("res://assets/textures/building_images/laboratorium_image.png")
var terrarium_img = preload("res://assets/textures/building_images/terrarium_image.png")
var watch_img = preload("res://assets/textures/building_images/watch_image.png")
var wonder_img = preload("res://assets/textures/building_images/wonder_image.png")


func _make_custom_tooltip(for_text):
	var tooltip = preload("res://scenes/game_scenes/tooltip_buildings.tscn").instantiate()
	tooltip.get_node("description").text = for_text
	tooltip.get_node("current_building").texture = current_building
	return tooltip


func _on_mouse_entered_house():
	current_building = house_img

func _on_mouse_entered_stock():
	current_building = stock_img
	
func _on_mouse_entered_lab():
	current_building = labor_img
func _on_mouse_entered_terrarium():
	current_building = terrarium_img
func _on_mouse_entered_farm():
	current_building = null
func _on_mouse_entered_bakery():
	current_building = bakery_img
func _on_mouse_entered_incub():
	current_building = incub_img
func _on_mouse_entered_watch():
	current_building = watch_img
func _on_mouse_entered_tempel():
	current_building = null
func _on_mouse_entered_carp():
	current_building = carpentry_img
func _on_mouse_entered_wonder():
	current_building = wonder_img
