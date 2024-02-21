extends Node3D

var sabotageEvents : Array
var housesInScenes : Array
var previousSabotagedHouse = null

signal sabotage_started

##[color=white]Interval for the Timer, on timeout -> check if sabotage valid[/color]
@export var sabotageCheckInterval = 5
var sabotageTimerCheck : Timer
##[color=white]How many[/color][color=green][b] houses[/b][/color] [color=white]does the player have to build so that the riots can happen[/color]
@export var house_threshold = 2


var selectedCitizen : CharacterBody3D
var start_check = false


# Called when the node enters the scene tree for the first time.
func _ready():
	sabotageEvents = get_children()
	BuildManager.houseSceneAdded.connect(add_houseScene_to_array)
	BuildManager.houseSceneRemoved.connect(remove_houseScene_from_array)
	sabotageTimerCheck = Timer.new()
	add_child(sabotageTimerCheck)
	sabotageTimerCheck.wait_time = sabotageCheckInterval
	sabotageTimerCheck.connect("timeout",check_if_sabotage_valid)
	sabotageTimerCheck.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start_check:
		check_if_house_got_deleted_by_player()

func add_houseScene_to_array(houseObj):
	housesInScenes.append(houseObj)
	print(str(houseObj) + " added")

func remove_houseScene_from_array(houseObj):
	if housesInScenes.has(houseObj):
		housesInScenes.erase(houseObj)
		print(str(houseObj) + " removed")

func check_if_sabotage_valid():
	# SHOULD THIS BE HAPPINESS OR INSPIRATION?
	# WE DONT HAVE ANY INCREASE IN HAPPINESS ATM
	if housesInScenes.size() > house_threshold and GameManager.riotAllowed and GameManager.population > 3:
		
		sabotageTimerCheck.stop()
		randomize()
		var randomHouseInt = randi_range(0, housesInScenes.size()-1)
		#var randomSabotageInt = randi_range(0,sabotageEvents.size()-1)
		var randomSabotageInt = 0
		var randomHouse = housesInScenes[randomHouseInt]
		
		## Tornado kinda buggy
		var randomEvent = sabotageEvents[0]
		#We let the npc walk to the house if it is FIRE
		if randomSabotageInt == 0:
			citizen_walk_towards_house(randomHouse)
			await selectedCitizen.reachedSabotageHouse
		
		
			if previousSabotagedHouse != randomHouse:
				start_sabotage(randomHouse, randomEvent)
			else:
				sabotageTimerCheck.start()
		
func check_if_house_got_deleted_by_player():
	if not is_instance_valid(selectedCitizen.sabotageHouse):
		sabotageTimerCheck.start()
		print("started Timer")
		start_check = false

func start_sabotage(obj, sabotage_type):
	sabotage_started.emit()
	#print(str(obj)+ "wird sabotiert mit: " + str(sabotage_type))
	if sabotage_type.name == "Fire":
		obj.isBurning = true
		obj.sabotageType = sabotage_type
		print(obj)
		sabotage_type.execute_sabotage_to(obj)
		previousSabotagedHouse = obj

#		await get_tree().create_timer(5).timeout
#
#		#this has to be called when we extinguish the building. Currently its on a timer :D
#		sabotage_type.fire_stopped(obj)
#		sabotageTimerCheck.wait_time = sabotageCheckInterval
#		sabotageTimerCheck.start()



	if sabotage_type.name == "Tornado":
		sabotage_type.travel_to_house(obj)
		previousSabotagedHouse = obj
#
		await get_tree().create_timer(5).timeout
#
#		#this has to be called when we extinguish the building. Currently its on a timer :D
		sabotage_type.stop_tornado(obj)
		sabotageTimerCheck.wait_time = sabotageCheckInterval
		sabotageTimerCheck.start()

func start_sabotage_timer():
	sabotageTimerCheck.wait_time = sabotageCheckInterval
	sabotageTimerCheck.start()
	
func citizen_walk_towards_house(house):
	selectedCitizen = get_tree().get_nodes_in_group("npc").pick_random()
	selectedCitizen.reachedSabotageHouse.connect(reachedHouse)
	print(" Citizen selected " + str(selectedCitizen))
	if not selectedCitizen.current_task == selectedCitizen.TASK.WALKING:
		citizen_walk_towards_house(house)
	else:
		selectedCitizen.sabotageHouse = house
		start_check = true
		selectedCitizen.current_task = selectedCitizen.TASK.RIOT
func reachedHouse():
	await get_tree().create_timer(5).timeout
		

