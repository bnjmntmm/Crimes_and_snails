extends Node3D

var sabotageEvents : Array
var housesInScenes : Array

var previousSabotagedHouse = null

#5 way to low. 45s atleast
@export var sabotageCheckInterval = 5

@export var happinessCheckValue = -1
var sabotageTimerCheck : Timer

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
	pass

func add_houseScene_to_array(houseObj):
	housesInScenes.append(houseObj)
	print(str(houseObj) + " added")

func remove_houseScene_from_array(houseObj):
	housesInScenes.erase(houseObj)
	print(str(houseObj) + " removed")

func check_if_sabotage_valid():
	if GameManager.happiness < happinessCheckValue and housesInScenes.size() > 0:
		sabotageTimerCheck.stop()
		randomize()
		var randomHouseInt = randi_range(0, housesInScenes.size()-1)
		var randomSabotageInt = randi_range(0,sabotageEvents.size()-1)
		var randomHouse = housesInScenes[randomHouseInt]
		var randomEvent = sabotageEvents[randomSabotageInt]
		if previousSabotagedHouse != randomHouse:
			start_sabotage(randomHouse, randomEvent)
		else:
			sabotageTimerCheck.start()
		
		
func start_sabotage(obj, sabotage_type):
	print(str(obj)+ "wird sabotiert mit: " + str(sabotage_type))
	if sabotage_type.name == "Fire":
		sabotage_type.execute_sabotage_to(obj)
		previousSabotagedHouse = obj

		await get_tree().create_timer(5).timeout
		
		#this has to be called when we extinguish the building. Currently its on a timer :D
		sabotage_type.fire_stopped(obj)
		sabotageTimerCheck.wait_time = sabotageCheckInterval
		sabotageTimerCheck.start()
	if sabotage_type.name == "Tornado":
		sabotage_type.travel_to_house(obj)
		previousSabotagedHouse = obj
		
		await get_tree().create_timer(5).timeout
		
		#this has to be called when we extinguish the building. Currently its on a timer :D
		sabotage_type.stop_tornado(obj)
		sabotageTimerCheck.wait_time = sabotageCheckInterval
		sabotageTimerCheck.start()
