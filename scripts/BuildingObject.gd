extends Node3D




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


func _ready():
	$Area.area_entered.connect(_on_area_entered)
	$Area.area_exited.connect(_on_area_exited)
func run_spawn():
	if can_spawn_actor:
		pass
func run_despawn():
	if can_spawn_actor:
		pass

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

	
