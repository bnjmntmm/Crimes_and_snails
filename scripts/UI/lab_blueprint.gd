extends Control

##PACKED SCENES
var big_house = preload("res://scenes/building_scenes/big_house.tscn")
var big_stock = preload("res://scenes/building_scenes/big_stock.tscn")

@onready var building_name_label = $BuildingName
@onready var upgrade_button = $UpgradeButton
@onready var price_label = $price_label


var building_name : String
var is_upgraded : bool = false

var object = null

@export var upgrade_price_house = 10
@export var upgrade_price_stock = 10


func _ready():
	building_name_label.text = str(building_name).rstrip("0123456789")
	if object.is_in_group("house"):
		price_label.text = "x " + str(upgrade_price_house)
	if object.is_in_group("stock"):
		price_label.text = "x " + str(upgrade_price_stock)



func _on_upgrade_button_button_down():
	is_upgraded	= true
	if object.is_in_group("house") and not object.is_in_group("big_house"):
		var upgraded_building = big_house.instantiate()
		var parent_obj = object.get_parent()
		parent_obj.add_child(upgraded_building)
		upgraded_building.global_position = object.global_position
		upgraded_building.name = object.name
		is_upgraded = true
		#state_changed.emit()
		object.queue_free()
		GameManager.inspiration = GameManager.inspiration - upgrade_price_house
		
	if object.is_in_group("stock") and not object.is_in_group("big_stock"):
		var upgraded_building = big_stock.instantiate()
		var parent_obj = object.get_parent()
		parent_obj.add_child(upgraded_building)
		upgraded_building.global_position = object.global_position
		upgraded_building.name = object.name
		is_upgraded = true
		#state_changed.emit()
		object.queue_free()
		GameManager.inspiration = GameManager.inspiration - upgrade_price_stock
		GameManager.stock_array.erase(object)
		GameManager.stock_array.append(upgraded_building)
		
