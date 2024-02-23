extends Control

var current_building_img
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
var farm_img = preload("res://assets/textures/building_images/farm_image.png")


##Houses to Get the resources they need
var House: PackedScene =ResourceLoader.load("res://scenes/building_scenes/house.tscn")
var Stock: PackedScene=ResourceLoader.load("res://scenes/building_scenes/stock.tscn")
var Terrarium: PackedScene = ResourceLoader.load("res://scenes/building_scenes/terrarium.tscn")
var Incubator: PackedScene = ResourceLoader.load("res://scenes/building_scenes/incubator.tscn")
var Lab: PackedScene = ResourceLoader.load("res://scenes/building_scenes/laboratorium.tscn")
var Bakery: PackedScene=ResourceLoader.load("res://scenes/building_scenes/bakery.tscn")
var Carpentry: PackedScene=ResourceLoader.load("res://scenes/building_scenes/carpentry.tscn")
var Watch : PackedScene = ResourceLoader.load("res://scenes/building_scenes/watch.tscn")
var Wonder : PackedScene = ResourceLoader.load("res://scenes/building_scenes/wonder.tscn")
var Farm : PackedScene= ResourceLoader.load("res://scenes/building_scenes/farm.tscn")



func _make_custom_tooltip(for_text):
	
	var tooltip = preload("res://scenes/game_scenes/tooltip_buildings.tscn").instantiate()
	tooltip.get_node("description").text = for_text
	tooltip.get_node("current_building").texture = current_building_img
	tooltip.get_node("HBoxContainer/VBoxContainer2/snails_value").text = str(current_building.snail_cost)
	tooltip.get_node("HBoxContainer/VBoxContainer2/wood_value").text = str(current_building.wood_cost)
	tooltip.get_node("HBoxContainer/VBoxContainer2/planks_value").text = str(current_building.plank_cost)
	return tooltip


func _on_mouse_entered_house():
	current_building_img = house_img
	current_building = House.instantiate()

func _on_mouse_entered_stock():
	current_building_img = stock_img
	current_building = Stock.instantiate()
	
func _on_mouse_entered_lab():
	current_building_img = labor_img
	current_building = Lab.instantiate()
func _on_mouse_entered_terrarium():
	current_building_img = terrarium_img
	current_building = Terrarium.instantiate()
func _on_mouse_entered_farm():
	current_building_img = farm_img
	current_building = Farm.instantiate()
func _on_mouse_entered_bakery():
	current_building_img = bakery_img
	current_building = Bakery.instantiate()
func _on_mouse_entered_incub():
	current_building_img = incub_img
	current_building = Incubator.instantiate()
func _on_mouse_entered_watch():
	current_building_img = watch_img
	current_building = Watch.instantiate()
func _on_mouse_entered_tempel():
	current_building_img = null
func _on_mouse_entered_carp():
	current_building_img = carpentry_img
	current_building = Carpentry.instantiate()
func _on_mouse_entered_wonder():
	current_building_img = wonder_img
	current_building = Wonder.instantiate()
