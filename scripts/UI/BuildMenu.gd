extends Control

@onready var new_land_buy_button : Button = $EditBuildingContainer/NewLandBuyButton
@onready var move : Button = $EditBuildingContainer/VBoxContainer/Move
@onready var delete : Button = $EditBuildingContainer/VBoxContainer/Delete


#icon textures
var delete_icon_normal := preload("res://assets/icon/house_delete_normal.png")
var delete_icon_hover := preload("res://assets/icon/house_delete_hover.png")

var move_icon_normal := preload("res://assets/icon/move_normal.png")
var move_icon_hover := preload("res://assets/icon/move_hover.png")

var new_land_normal := preload("res://assets/icon/land_buy.png")
var new_land_hover := preload("res://assets/icon/land_buy_hover3.png")



func _on_new_land_buy_button_mouse_entered():
	new_land_buy_button.icon = new_land_hover


func _on_new_land_buy_button_mouse_exited():
	new_land_buy_button.icon = new_land_normal


func _on_move_mouse_entered():
	move.icon = move_icon_hover


func _on_move_mouse_exited():
	move.icon = move_icon_normal


func _on_delete_mouse_entered():
	delete.icon = delete_icon_hover


func _on_delete_mouse_exited():
	delete.icon = delete_icon_normal

