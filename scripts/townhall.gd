extends Node3D

@onready var citizen=ResourceLoader.load("res://scenes/game_scenes/citizen.tscn")
@onready var check_for_tree_and_bush = $CheckForTreeAndBush
@onready var navigation_region_3d = $".."
@onready var audio_stream_player = $AudioStreamPlayer3D
@onready var inspiration_resource_timer = $InspirationResourceTimer
@onready var happiness_check_timer = $HappinessCheckTimer
@onready var duration_sad_timer = $DurationSadTimer




var spawn_ready:=false
var spawn_timer:=0.0
var spawn_interval:=20
var current_citizen
var current_pop:=0
var max_pop:= 10

var happy_citizen = 0

@export var citizen_food_consumption:=20
@export var citizen_housing_needs:=10

@export_range(5,10,0.01) var riot_threshold = 7


# Called when the node enters the scene tree for the first time.
func _ready():
	run_spawn()

func run_spawn():
	current_citizen=citizen.instantiate()
	
	
	get_tree().root.add_child(current_citizen,true)
	current_citizen.spawn_point=$SpawnPoint
	current_citizen.global_position=$SpawnPoint.global_position
	GameManager.population +=1
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
		#print(str(body) + " removed")
		
	if body.is_in_group("wood"):
		GameManager.tree_array.erase(body)
		body.queue_free()
		#print(str(body) + " removed")
		

func calculate_happy_citizens():
	var citizens_with_enough_food = min(GameManager.food/citizen_food_consumption, GameManager.population)
	var citizen_with_house = min(GameManager.houses_built*citizen_housing_needs, GameManager.population)
	happy_citizen = min(citizens_with_enough_food, citizen_with_house)
	return happy_citizen


func _on_random_events_sabotage_started():
	audio_stream_player.play(0)


func _on_fire_sabotage_stopped():
	audio_stream_player.stop()


func _on_tornado_sabotage_stopped():
	audio_stream_player.stop()


func _on_inspiration_resource_timer_timeout():
	if (GameManager.food-(GameManager.population*citizen_food_consumption))>0:
		GameManager.inspiration+=calculate_happy_citizens()
		#GameManager.food-=GameManager.population*citizen_food_consumption


func _on_happiness_check_timer_timeout():
	var happy_citiz = float(calculate_happy_citizens())
	if happy_citiz != 0 || GameManager.population != 0:
		var percentage = happy_citiz / float(GameManager.population)
		GameManager.happiness = percentage * 10
	
	if GameManager.happiness < riot_threshold:
		if not duration_sad_timer.time_left > 0:
			duration_sad_timer.start()
	else:
		duration_sad_timer.stop()
		GameManager.riotAllowed = false
		
		


func _on_duration_sad_timer_timeout():
	GameManager.riotAllowed = true
	
