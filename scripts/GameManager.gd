extends Node


enum State{
	PLAY,
	BUILD,
	DESTROY,
	POV_MODE,
	BUY_LAND,
	MOVE_HOUSE
}
var current_state=State.PLAY

var food:=0
var wood:=0
var planks:=0
var snails:=0
var happiness:=0

var population:=0
var max_population
var available_population
var citizen: PackedScene

var current_price_for_land:= 10
var BasePrice := 10
var numberOfBoughtLands := 0
var winChecker = WinCondition.new()
var opened_npc_menu = false

#### Navigation 
var tree_array = []
var bush_array = []

var stock_array = []






#Checks if WinCondition is erreicht, when condition != null also no condition erreicht, nothing happens
#else its spammed :D

#Question: Pause the Game? Make a hud visible to "continue" or stop? Maybe a Score? Idk
func _process(delta):
	var condition = winChecker.checkIfWinCondition()
	if condition != null:
		print("Win by: " +str(condition))
