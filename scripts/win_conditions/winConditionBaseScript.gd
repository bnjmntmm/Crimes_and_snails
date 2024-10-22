extends Node
class_name WinCondition

var npcCountTarget : int = 80
var foodCountTarget : int = 5000
var snailCountTarget : int = 1000
var landBoughtTarget : int = 20
var savedSabotages : int = 50


enum WIN_CONDITION{
	NPC,
	FOOD,
	SNAIL,
	LAND,
	WONDER,
	SAVED_SABOTAGES
}

var current_winCondition

func get_npc_target_count():
	return npcCountTarget
func get_food_target_count():
	return foodCountTarget
func get_snail_target_count():
	return snailCountTarget
func get_land_bought_target():
	return landBoughtTarget
func get_saved_sabotages_count():
	return savedSabotages


func checkIfWinCondition():
	if GameManager.population >= npcCountTarget:
		current_winCondition = WIN_CONDITION.NPC
	elif GameManager.food >= foodCountTarget:
		current_winCondition = WIN_CONDITION.FOOD
	elif GameManager.snails >= snailCountTarget:
		current_winCondition = WIN_CONDITION.SNAIL
	elif GameManager.numberOfBoughtLands >= landBoughtTarget:
		current_winCondition = WIN_CONDITION.LAND
	elif GameManager.isWonderBuild:
		current_winCondition = WIN_CONDITION.WONDER
	elif GameManager.sabotages_stopped >= savedSabotages:
		current_winCondition = WIN_CONDITION.SAVED_SABOTAGES
	else:
		current_winCondition = null
	return current_winCondition
	
