extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HBoxContainer2/RessourceValues/SnailsValue.text=str(GameManager.snails)
	$HBoxContainer2/RessourceValues/HappinessValue.text=str(GameManager.happiness)
	$HBoxContainer2/RessourceValues/FoodValue.text=str(GameManager.food)
	$HBoxContainer2/RessourceValues/WoodValue.text=str(GameManager.wood)
	$HBoxContainer2/RessourceValues/PlanksValue.text=str(GameManager.planks)
	
func _on_area_2d_area_entered(area):
	BuildManager.able_to_build=false


func _on_area_2d_area_exited(area):
	BuildManager.able_to_build=true
	
func _on_house_button_down():
	BuildManager.spawn_house()

func _on_stock_button_down():
	BuildManager.spawn_stock()
