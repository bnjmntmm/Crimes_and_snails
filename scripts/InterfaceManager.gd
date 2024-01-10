extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$BuildMenu/HBoxContainer2/RessourceValues/SnailsValue.text=str(GameManager.snails)
	$BuildMenu/HBoxContainer2/RessourceValues/HappinessValue.text=str(GameManager.happiness)
	$BuildMenu/HBoxContainer2/RessourceValues/FoodValue.text=str(GameManager.food)
	$BuildMenu/HBoxContainer2/RessourceValues/WoodValue.text=str(GameManager.wood)
	$BuildMenu/HBoxContainer2/RessourceValues/PlanksValue.text=str(GameManager.planks)
	$Population/PopulationValue.text=str(GameManager.population)
	if GameManager.current_state == GameManager.State.POV_MODE:
		visible= false
	else:
		visible = true
	
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



func _on_delete_button_down():
	GameManager.current_state = GameManager.State.DESTROY


func _on_move_button_down():
	GameManager.current_state = GameManager.State.MOVE_HOUSE
