extends Node
class_name WinCondition

var npcCountTarget : int = 200
var foodCountTarget : int = 200
var snailCountTarget : int = 1000
var landBoughtTarget : int = 50

enum WIN_CONDITION{NPC, FOOD, SNAIL, LAND}

var current_winCondition = null

func get_npc_target_count():
	return npcCountTarget
func get_food_target_count():
	return foodCountTarget
func get_snail_target_count():
	return snailCountTarget
func get_land_bought_target():
	return landBoughtTarget


func checkIfWinCondition():
	if GameManager.population >= npcCountTarget:
		current_winCondition = WIN_CONDITION.NPC
	elif GameManager.food >= foodCountTarget:
		current_winCondition = WIN_CONDITION.FOOD
	elif GameManager.snails >= snailCountTarget:
		current_winCondition = WIN_CONDITION.SNAIL
	elif GameManager.numberOfBoughtLands >= landBoughtTarget:
		current_winCondition = WIN_CONDITION.LAND
	else:
		current_winCondition = null
	return current_winCondition
	
