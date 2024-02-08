extends Node3D


@onready var audio_stream_player = $AudioStreamPlayer3D
@onready var sabotage_point = $SabotagePoint


@export var can_spawn_actor :=true
@export var actor: PackedScene

 
@export var wood_cost: int
@export var plank_cost: int
@export var food_cost: int
@export var snail_cost:int

var objects:Array=[]
var active_buildable_object: bool
var spawned:=false
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


@onready var right_cast := $NavPlaneCheck/RightCast
@onready var left_cast := $NavPlaneCheck/LeftCast
@onready var up_cast := $NavPlaneCheck/UpCast
@onready var down_cast := $NavPlaneCheck/DownCast


func _ready():
	$Area.area_entered.connect(_on_area_entered)
	$Area.area_exited.connect(_on_area_exited)
	$Area.body_entered.connect(_on_body_entered)
	$Area.body_exited.connect(_on_body_exited)
#func run_spawn():
#	if can_spawn_actor:
#		pass
#func run_despawn():
#	if can_spawn_actor:
#		pass

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
		if objects.size()>=0:
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

