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
var wheat:=100
var happiness:=0
var inspiration:=0
var population:=0
var houses_built:=0
var sabotages_stopped:=0

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
var opened_lab_menu = false


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

var winConditionTimer : Timer

var inGame = false
var riotAllowed = false


#Watches
var watch_particles_array : Array = []

var main_node : Node3D


##TEMPLE BUILD WIN CONDITITION
var isTempleBuild = false

var selected_win_condition = null


func _ready():
	winConditionTimer = Timer.new()
	winConditionTimer.wait_time = 0.3
	winConditionTimer.timeout.connect(checkIfWinConditionReached)

#Checks if WinCondition is erreicht, when condition != null also no condition erreicht, nothing happens
#else its spammed :D

#Question: Pause the Game? Make a hud visible to "continue" or stop? Maybe a Score? Idk
func _process(delta):
	if inGame:
		winConditionTimer.start()
		if(!get_tree().paused):
			game_time += delta
		else:
			winConditionTimer.stop()
			
		seconds = fmod(game_time, 60)
		minutes = fmod(game_time, 60*60) / 60
	

		
func checkIfWinConditionReached():
	var condition = winChecker.checkIfWinCondition()
	if condition != null:
		if condition == selected_win_condition:
			print("Win by: " + str(condition))
	

func emitting_watch_particles():
	for particle in watch_particles_array:
		particle.visible = !particle.visible
		particle.emitting = !particle.emitting
		


