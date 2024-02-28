extends Node3D

@onready var audio_stream_player = $AudioStreamPlayer3D
@onready var sabotage_point = $SabotagePoint

@onready var right_cast := $NavPlaneCheck/RightCast
@onready var left_cast := $NavPlaneCheck/LeftCast
@onready var up_cast := $NavPlaneCheck/UpCast
@onready var down_cast := $NavPlaneCheck/DownCast
@onready var watch_tower_particles = $WatchArea/watch_particles
@onready var fire_marker := $FireLocation

#just for the wonder
@onready var wonder_timer : Timer = $WonderTimer


@export var can_spawn_actor := true
@export var actor: PackedScene

##[color=white]Riot Stop Check. Random Value has to be higher then the probabilty to 
##execute the riot
@export_range(1,100,0.1) var riotStopProbability :float = 50.0


@export var wood_cost: int
@export var plank_cost: int
@export var food_cost: int
@export var snail_cost: int

@export var is_crafting_building := false
@export var crafted_resource_ammount := 0
@export var raw_to_refined_ratio := 0
@export_enum("planks","bread","wheat") var crafted_resource: String
@onready var crafting_timer = $CraftingTimer
@onready var crafting_progress = $CraftingProgress
@export var crafting_time := 10.0
var current_time := crafting_time

var objects: Array = []
var active_buildable_object: bool
var spawned := false
var current_actor

var isBurning = false
var isDestroyed = false
var sabotageType = null
var fire_scene : GPUParticles3D = null

var isTornado = false
var tornado_scene = null

#Foliage Array to remove when house is placed
var collidingObjects := []

var old_plane = null





func _ready():
	$Area.area_entered.connect(_on_area_entered)
	$Area.area_exited.connect(_on_area_exited)
	$Area.body_entered.connect(_on_body_entered)
	$Area.body_exited.connect(_on_body_exited)
	if is_crafting_building:
		crafting_timer.start()
func _on_body_entered(body):
	var bodyName = body.name.rstrip("0123456789")
	if bodyName == "Bush" or bodyName == "Tree":
		collidingObjects.append(body)
func _on_body_exited(body):
	var bodyName = body.name.rstrip("0123456789")
	if bodyName == "Bush" or bodyName == "Tree":
		collidingObjects.erase(body)
		

func _on_area_entered(area):

	if active_buildable_object:
		objects.append(area)
		BuildManager.able_to_build=false

func _on_area_exited(area):
	if active_buildable_object:
		objects.erase(area)
		if objects.size()<=0:
			BuildManager.able_to_build=true

func set_disabled(enabled):
		$CollisionShape.disabled=enabled
	
func remove_foliage():
	for i in collidingObjects:
		i.queue_free()
		if i.is_in_group("food"):
			GameManager.bush_array.erase(i)
		if i.is_in_group("wood"):
			GameManager.tree_array.erase(i)



#RAYCASTS
func get_right_cast():
	return $NavPlaneCheck.get_right_cast()
func get_left_cast():
	return $NavPlaneCheck.get_left_cast()
func get_up_cast():
	return $NavPlaneCheck.get_up_cast()
func get_down_cast():
	return $NavPlaneCheck.get_down_cast()
	

func craft_resource():
	match crafted_resource:
		"planks":
			if GameManager.wood>=crafted_resource_ammount*raw_to_refined_ratio:
				GameManager.wood-=crafted_resource_ammount*raw_to_refined_ratio
				GameManager.planks+=crafted_resource_ammount
				
		"bread":
			if GameManager.wheat>=crafted_resource_ammount*raw_to_refined_ratio:
				GameManager.food+=crafted_resource_ammount
				GameManager.wheat-=crafted_resource_ammount*raw_to_refined_ratio
				
		"wheat":
			GameManager.wheat+=crafted_resource_ammount


func _on_crafting_timer_timeout():
	if self.name.contains("carpentry"):
		if GameManager.carpentry_running:
			self.current_time-=0.1
			update_progress_bar()
		
	else:
		self.current_time-=0.1
		update_progress_bar()
	
func update_progress_bar():
	var progress=(crafting_time-current_time)/crafting_time
	if progress>=1:
		#crafting_progress.value=0
		progress=0
		self.current_time=crafting_time
		craft_resource()
	self.crafting_progress.value=progress


func _on_watch_area_body_entered(body):
	if spawned:
		if body.current_task == body.TASK.RIOT:
			print("rioter entered")
			change_to_stop_rioter(body)


func _on_watch_area_body_exited(body):
	if spawned:
		if body.current_task == body.TASK.RIOT:
			print("rioter exited")

func get_watch_particles():
	return watch_tower_particles 

func get_fire_spot_location():
	return fire_marker.global_position

#Chance for the Watch to stop the 
func change_to_stop_rioter(body):
	var random_value = randi() % 100
	if random_value < riotStopProbability:
		body.reset_npc()
		print("riot was stopped")
		GameManager.sabotages_stopped += 1
		GameManager.main_node.find_child("random_events").start_sabotage_timer()
	else:
		print("riot was not stopped")


func _on_wonder_timer_timeout():
	GameManager.isWonderBuild = true
	print("buuiild")
