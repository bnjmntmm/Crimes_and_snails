extends Control

var win_condition_blueprint = preload("res://scenes/utils/win_condition_blueprint.tscn")
@onready var v_box_container = $Panel/VBoxContainer

var wincon_instantiate

@export var loading_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	wincon_instantiate = WinCondition.new()
	var index = 1
	for state in WinCondition.WIN_CONDITION:
		var win_condition_selector := win_condition_blueprint.instantiate()
		v_box_container.add_child(win_condition_selector)
		win_condition_selector.set_label_text(str(index) + ". " + checkLabelForCorrectName(state))
		win_condition_selector.win_state = state
		win_condition_selector.loading_scene = loading_scene
		index += 1
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func checkLabelForCorrectName(state):
	if state == "NPC":
		return "Have " + str(wincon_instantiate.get_npc_target_count()) + " NPCs"
	elif state == "FOOD":
		return "Have " + str(wincon_instantiate.get_food_target_count()) + " Food Resources"
	elif state == "SNAIL":
		return "Have " + str(wincon_instantiate.get_snail_target_count()) + " Snails"
	elif state == "LAND":
		return "Bought more than " + str(wincon_instantiate.get_land_bought_target()) + " Lands"
	elif state == "TEMPLE":
		return "Build the final and expensive Temple"
	elif state == "SAVED_SABOTAGES":
		return "Stop more than " + str(wincon_instantiate.get_saved_sabotages_count()) + " Sabotages"
	
