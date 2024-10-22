extends Control

signal lab_menu_signal

@export var main_menu : PackedScene


@onready var happiness_texture : TextureRect = $TopUI/HappinessPopuPanel/Happiness


var happySmile = preload("res://assets/textures/HUD/Happiness.png")
var neutralSmile = preload("res://assets/textures/HUD/neutralFace.PNG")
var madSmile = preload("res://assets/textures/HUD/MadFace.PNG")

var recalcJustOnce : bool = true


signal switchToBuyLandCamera



# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.inGame = true
	Settings.world_environement = $"../WorldEnvironment"
	Settings.light = $"../Sun"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$TopUI/ResourcePanel/SnailLabel.text=str(GameManager.snails)
	$TopUI/ResourcePanel/MaxSnailLabel.text = "/ " + str(GameManager.maxSnails)
#	$BuildMenu/ResourceContainer/RessourceValues/HappinessValue.text=str(GameManager.inspiration)
	$TopUI/ResourcePanel/FoodLabel.text=str(GameManager.food)
	$TopUI/ResourcePanel/WoodRawLabel.text=str(GameManager.wood)
	$TopUI/ResourcePanel/WoodPlanksLabel.text=str(GameManager.planks)
	$TopUI/ResourcePanel/WheatLabel.text = str(GameManager.wheat)
	$TopUI/HappinessPopuPanel/PopulationValue.text=str(GameManager.population)

	$TopUI/HappinessPopuPanel/InspirationsLabel.text = str(GameManager.inspiration)
	if GameManager.showFPSInScreen:
		$FPS.visible = true
	else:
		$FPS.visible = false
	$TopUI/TimerPanel/Time.text = "%02d : %02d" % [GameManager.minutes, GameManager.seconds]
	$FPS.text = str("FPS %d" % Engine.get_frames_per_second())
	check_happiness()

	if GameManager.current_state == GameManager.State.POV_MODE:
		visible= false
	else:
		visible = true
	
	if GameManager.current_state == GameManager.State.PLAY:
		$BuildMenu/DeletionPanel.visible = false
		$BuildMenu/MovingPanel.visible = false
	
	if GameManager.current_state == GameManager.State.DESTROY:
		$BuildMenu/DeletionPanel.visible = true
		$BuildMenu/MovingPanel.visible = false
	if GameManager.current_state == GameManager.State.MOVE_HOUSE:
		$BuildMenu/MovingPanel.visible = true
		$BuildMenu/DeletionPanel.visible = false
		
	if GameManager.opened_house_menu:
		$LabMenu.visible = false
		$CarpentryMenu.visible = false
		$CraftMenu.visible = true
	else:
		$CraftMenu.visible = false
		
	if GameManager.opened_carpentry_menu:
		$CarpentryMenu.visible=true
		$LabMenu.visible = false
		$CraftMenu.visible = false
	else:
		$CarpentryMenu.visible=false
		
	if GameManager.opened_lab_menu:
		if recalcJustOnce:
			recalcJustOnce = false
			$CraftMenu.visible = false
			$CarpentryMenu.visible = false
			$LabMenu.visible = true
			lab_menu_signal.emit()
	else:
		recalcJustOnce = true
		$LabMenu.visible = false
		
	if GameManager.winScreenOpened:
		$WinScreen.visible = true
	
func _on_area_2d_area_entered(area):
	BuildManager.able_to_build=false


func _on_area_2d_area_exited(area):
	BuildManager.able_to_build=true
	
func _on_house_button_down():
	BuildManager.spawn_house()

func _on_stock_button_down():
	BuildManager.spawn_stock()


func _on_terrarium_button_down():
	BuildManager.spawn_terrarium()


func _on_incubator_button_down():
	BuildManager.spawn_incubator()


func _on_lab_button_down():
	BuildManager.spawn_lab()


func _on_bakery_button_down():
	BuildManager.spawn_bakery()


func _on_carpentry_button_down():
	BuildManager.spawn_carpentry()


func _on_watch_button_down():
	BuildManager.spawn_watch()
func _on_wonder_button_down():
	BuildManager.spawn_wonder()



func _on_delete_button_down():
	$BuildMenu/DeletionPanel.visible = true
	GameManager.current_state = GameManager.State.DESTROY


func _on_move_button_down():
	$BuildMenu/MovingPanel.visible = true
	GameManager.current_state = GameManager.State.MOVE_HOUSE


func check_happiness():

	if GameManager.currentHappinesRatio >= GameManager.happyInspiration:
		happiness_texture.texture = happySmile
	elif GameManager.currentHappinesRatio < GameManager.happyInspiration and GameManager.currentHappinesRatio > GameManager.mediumInspiration:
		happiness_texture.texture = neutralSmile
	else:
		happiness_texture.texture = madSmile


func _on_settings_settings_closed():
	$TopUI.visible = true
	$BuildMenu.visible = true
	get_tree().paused = false


func _on_settings_menu_pressed():
	get_tree().paused = true
	$Settings.visible = true
	$TopUI.visible = false
	$BuildMenu.visible = false


func _on_farm_button_down():
	BuildManager.spawn_farm()



func _on_new_land_buy_button_button_down():
	GameManager.current_state = GameManager.State.BUY_LAND
	switchToBuyLandCamera.emit()
	$BuildMenu/MovingPanel.visible = false
	$BuildMenu/DeletionPanel.visible = false


func _on_continue_building_button_down():
	GameManager.infiniteBuilding = true
	GameManager.winScreenOpened = false
	$WinScreen.visible = false
	get_tree().paused = false
	


func _on_back_to_menu_button_down():
	get_tree().quit()


func _on_back_to_menu_tab_clicked(tab):
	if tab == 2:
		var all_npcs = get_tree().get_nodes_in_group("npc")
		for i in range(len(all_npcs)):
			all_npcs[i].queue_free()
		get_tree().paused=false
		get_tree().quit()
		
		#get_tree().reload_current_scene()

