extends Control


var lab_item : PackedScene = preload("res://scenes/utils/lab_blueprint.tscn")
@onready var houses_v_box = $Panel/TabContainer/Houses/HousesVBox
@onready var stocks_v_box = $Panel/TabContainer/Stocks/StocksVBox
@onready var watches_v_box = $Panel/TabContainer/Watches/WatchesVBox

@onready var tab_container = $Panel/TabContainer


var house_array
var stock_array
var watch_array

var labItemArray = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func generate_controls():
	for house in house_array:
		if labItemArray.has(house) or house.is_in_group("big_house"):
			continue
		var newLabItem = lab_item.instantiate()
		newLabItem.building_name = house.name
		newLabItem.object = house
		newLabItem.emit_signal("name_changed")
		newLabItem.is_upgraded = false
		newLabItem.scale = Vector2(0.4,0.4)
		houses_v_box.add_child(newLabItem,true)
		labItemArray[house] = lab_item
		
	for stock in stock_array:
		if labItemArray.has(stock) or stock.is_in_group("big_stock"):
			continue
		var newLabItem = lab_item.instantiate()
		newLabItem.building_name  = stock.name
		newLabItem.object = stock
		newLabItem.emit_signal("name_changed")
		newLabItem.is_upgraded = false
		newLabItem.scale = Vector2(0.4,0.4)
		stocks_v_box.add_child(newLabItem,true)
		labItemArray[stock] = lab_item
	for watch in watch_array:
		if labItemArray.has(watch) or watch.is_in_group("big_watch"):
			continue
		var newLabItem = lab_item.instantiate()
		newLabItem.building_name = watch.name
		newLabItem.object = watch
		newLabItem.emit_signal("name_changed")
		newLabItem.is_upgraded = false
		newLabItem.scale = Vector2(0.4,0.4)
		watches_v_box.add_child(newLabItem,true)
		labItemArray[watch] = lab_item
		
		
		
		

func delete_all_children():
	for n in houses_v_box.get_children():
		n.queue_free()
	for n in stocks_v_box.get_children():
		n.queue_free()
	for n in watches_v_box.get_children():
		n.queue_free()


func _on_hud_lab_menu_signal():
	tab_container.visible = false
	#delete_all_children()
	house_array = get_tree().get_nodes_in_group("house")
	for item in house_array:
		if item.is_in_group("big_house"):
			house_array.erase(item)
	stock_array = get_tree().get_nodes_in_group("stock")
	for item in stock_array:
		if item.is_in_group("big_stock"):
			stock_array.erase(item)
	watch_array = get_tree().get_nodes_in_group("watch")
	for item in watch_array:
		if item.is_in_group("big_watch"):
			watch_array.erase(item)
	generate_controls()
	tab_container.visible = true


func _on_button_button_down():	
	GameManager.opened_lab_menu = false
	visible = false
