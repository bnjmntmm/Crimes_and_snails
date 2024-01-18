extends Control

@onready var craft_menu = $"."

var currentBerries = 0
var currentWood = 0

var foodRest = 0
var woodRest = 0
var foodToSnailCounter = 0
var woodToSnailCounter = 0

@onready var counter_berry := $Panel/BerryIcon/counterBerry
@onready var counter_wood = $Panel/WoodIcon/counterWood
@onready var snailsCost := $Panel/Label/Snails


#buttons
@onready var confirm_button = $Panel/HBoxContainer/ConfirmButton
@onready var confirm_again = $Panel/HBoxContainer/ConfirmAgain




var red = Color(1.0,0.0,0.0,1.0)
var white = Color.WHITE

# SNAIL CALCULATIONS

# food 12 : 1 Snail
# wood 12 : 1 Snail
@export var price = 4

func calcCurrentSnails():
	foodToSnailCounter = 0
	woodToSnailCounter = 0
	var berries = currentBerries
	var wood = currentWood
	while berries >= price:
		foodToSnailCounter += 1
		berries = berries - price
	while wood >= price:
		woodToSnailCounter += 1
		wood = wood - price
	


func _on_close_button_button_down():
	currentBerries = 0
	currentWood = 0
	counter_berry.text = str(0)
	counter_wood.text = str(0)
	GameManager.opened_house_menu = false
	craft_menu.visible = false


func _on_add_berry_button_down():
	resetButtons()	
	currentBerries += 4
	if currentBerries <= GameManager.food:
		confirm_button.disabled = false
		
		counter_berry.set("theme_override_colors/font_color", Color.WHITE)
	else:
		confirm_button.disabled = true
		currentBerries -= 4
		counter_berry.set("theme_override_colors/font_color", Color.RED)
	counter_berry.text = str(currentBerries)



#### CAN BE IMPROVED


func _on_minus_berry_button_down():
	resetButtons()
	if currentBerries >= 4:
		currentBerries -= 4
		counter_berry.text = str(currentBerries)
		if currentBerries < GameManager.food:
			confirm_button.disabled = false
			counter_berry.set("theme_override_colors/font_color", Color.WHITE)
		else:
			confirm_button.disabled = true
			counter_berry.set("theme_override_colors/font_color", Color.RED)

func _on_add_wood_button_down():
	resetButtons()
	currentWood += 4
	if currentWood <= GameManager.wood:

		confirm_button.disabled = false
		counter_wood.set("theme_override_colors/font_color", Color.WHITE)
	else:
		confirm_button.disabled = true
		currentWood -= 4
		counter_wood.set("theme_override_colors/font_color", Color.RED)
	counter_wood.text = str(currentWood)


func _on_minus_wood_button_down():
	resetButtons()
	if currentWood >= 4:
		currentWood -= 4
		counter_wood.text = str(currentWood)
		if currentWood < GameManager.wood:
			confirm_button.disabled = false
			counter_wood.set("theme_override_colors/font_color", Color.WHITE)
		else:
			confirm_button.disabled = true
			counter_wood.set("theme_override_colors/font_color", Color.RED)



func _on_confirm_button_button_down():
	confirm_button.visible = false
	confirm_again.visible = true
	calcCurrentSnails()
	if currentWood <= GameManager.wood and currentBerries <= GameManager.food:
		snailsCost.text = str(foodToSnailCounter + woodToSnailCounter)
	
		
func resetButtons():
	confirm_again.visible = false
	confirm_button.visible = true


func _on_confirm_again_button_down():
	currentBerries = 0
	currentWood = 0
	counter_berry.text = str(0)
	counter_wood.text = str(0)
	GameManager.snails = GameManager.snails + (foodToSnailCounter+woodToSnailCounter)
	GameManager.wood = GameManager.wood - (woodToSnailCounter*4)
	GameManager.food = GameManager.food - (foodToSnailCounter*4)
	resetButtons()
	GameManager.opened_house_menu = false
