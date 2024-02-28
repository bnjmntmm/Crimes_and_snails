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

<<<<<<< Updated upstream
var food:=10
var wood:=0
=======
var food:=0
var wood:=1000
>>>>>>> Stashed changes
var planks:=0
var snails:=0
var wheat:=0
var happiness:=0
var inspiration:=0
var population:=0
var houses_built:=1
var sabotages_stopped:=0

var snailsPerTerrarium : int = 50
var baseSnailamount : int = 200
var maxSnails : int = 0
var terrariumsPlaced : int = 0


####INSPIRATION CHECK
var happyInspiration = 0.7
var mediumInspiration = 0.5
var madInspiration = 0.1


var citizen: PackedScene

var current_price_for_land:= 10
var BasePrice := 10
var numberOfBoughtLands := 0
var winChecker = WinCondition.new()
var opened_npc_menu = false


var opened_house_menu = false
var opened_carpentry_menu=false
var first_area_generated = false
var opened_lab_menu = false
var carpentry_running:= true

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
var firstState = true

var winScreenOpened : bool = false
var infiniteBuilding: bool = false
var currentHappinesRatio : float = 0.0


#Watches
var watch_particles_array : Array = []

var main_node : Node3D


##TEMPLE BUILD WIN CONDITITION
var isWonderBuild = false

var selected_win_condition = null


func _ready():
	winConditionTimer = Timer.new()
	winConditionTimer.wait_time = 0.3
	winConditionTimer.timeout.connect(checkIfWinConditionReached)
	maxSnails = baseSnailamount
	add_child(winConditionTimer)

func _process(delta):
	if inGame:
		if firstState and not infiniteBuilding:
			winConditionTimer.start()
			firstState = false
		if(!get_tree().paused):
			game_time += delta
		else:
			firstState = true
			winConditionTimer.stop()
		
			
		seconds = fmod(game_time, 60)
		minutes = fmod(game_time, 60*60) / 60
	

		
func checkIfWinConditionReached():
	var condition = winChecker.checkIfWinCondition()
	#print("check condition")
	if condition != null:
		if condition == selected_win_condition:
			print("Win by: " + str(condition))
			winScreenOpened= true
			get_tree().paused = true
			winConditionTimer.stop()
	#winConditionTimer.start()
	

func emitting_watch_particles():
	for particle in watch_particles_array:
		particle.visible = !particle.visible
		particle.emitting = !particle.emitting
		
func calculateNewMaxSnailAmount():
	maxSnails = baseSnailamount + (terrariumsPlaced * snailsPerTerrarium)

