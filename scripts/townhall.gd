extends Node3D

@onready var citizen=ResourceLoader.load("res://scenes/game_scenes/citizen.tscn")
@onready var check_for_tree_and_bush = $CheckForTreeAndBush
@onready var navigation_region_3d = $".."
@onready var inspiration_resource_timer = $InspirationResourceTimer


@export var citizen_food_consumption:=5
#each house can take 10 citizens
@export var citizen_housing_needs:=10
var spawn_ready:=false
var spawn_timer:=0.0
var spawn_interval:=3.0
var current_citizen
var current_pop:=0
var max_pop:= 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func run_spawn():
	current_citizen=citizen.instantiate()
	
	
	get_tree().root.add_child(current_citizen,true)
	current_citizen.spawn_point=$SpawnPoint
	current_citizen.global_position=$SpawnPoint.global_position
	GameManager.population+=1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawn_ready and current_pop<max_pop:
		spawn_timer += delta
		if spawn_timer >= spawn_interval:
			spawn_timer = 0  
			run_spawn()

		
		
func _enter_tree():
	spawn_ready=true


func _on_check_for_tree_and_bush_body_entered(body):
	if body.is_in_group("food"):
		GameManager.bush_array.erase(body)
		body.queue_free()
		print(str(body) + " removed")
		
	if body.is_in_group("wood"):
		GameManager.tree_array.erase(body)
		body.queue_free()
		print(str(body) + " removed")
		
	
func calculate_happy_citizens():
	var citizens_with_enough_food=min(GameManager.food/citizen_food_consumption,GameManager.population)
	var citizen_with_house=min(GameManager.houses_built*citizen_housing_needs,GameManager.population)
	var happy_citizens=min(citizens_with_enough_food,citizen_with_house)
	return happy_citizens

func _on_inspiration_resource_timer_timeout():
	
	if (GameManager.food-(GameManager.population*citizen_food_consumption))>0:
		GameManager.inspiration+=calculate_happy_citizens()
		GameManager.food-=GameManager.population*citizen_food_consumption
		
		
		
	
