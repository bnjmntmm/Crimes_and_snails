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
var inspiration:=0
var population:=0
var houses_built:=0


####INSPIRATION CHECK
var happyInspiration = 50
var mediumInspiration = 30
var madInspiration = 10


var citizen: PackedScene

var current_price_for_land:= 10
var BasePrice := 10
var numberOfBoughtLands := 0
var winChecker = WinCondition.new()
var opened_npc_menu = false

var opened_house_menu = false
var first_area_generated = false

#### Navigation 
var tree_array : Array = []
var bush_array : Array = []

var stock_array = []

var npc_in_charge = null


##Timer
var game_time = 0
var timer_on = false
var seconds = 0
var minutes = 0


var inGame = false



#Checks if WinCondition is erreicht, when condition != null also no condition erreicht, nothing happens
#else its spammed :D

#Question: Pause the Game? Make a hud visible to "continue" or stop? Maybe a Score? Idk
func _process(delta):
	
	if inGame:
		if(!get_tree().paused):
			game_time += delta
		seconds = fmod(game_time, 60)
		minutes = fmod(game_time, 60*60) / 60
		
	
	var condition = winChecker.checkIfWinCondition()
	if condition != null:
		print("Win by: " +str(condition))
		
	

		
