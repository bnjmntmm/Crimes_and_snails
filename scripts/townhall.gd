extends Node3D

@onready var citizen=ResourceLoader.load("res://scenes/game_scenes/citizen.tscn")
var spawn_ready:=false
var spawn_timer:=0.0
var spawn_interval:=3.0
var current_citizen
var current_pop:=0
var max_pop:=5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func run_spawn():
	current_citizen=citizen.instantiate()
	
	
	get_tree().root.add_child(current_citizen,true)
	current_citizen.spawn_point=$SpawnPoint
	current_citizen.global_position=$SpawnPoint.global_position
	current_pop+=1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawn_ready and current_pop<max_pop:
		spawn_timer += delta
		if spawn_timer >= spawn_interval:
			spawn_timer = 0  
			run_spawn()
		
		
		
func _enter_tree():
	spawn_ready=true
