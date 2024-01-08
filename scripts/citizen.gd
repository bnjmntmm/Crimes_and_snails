extends CharacterBody3D

@onready var navigation_agent = $NavigationAgent3D





enum TASK{
	GETTING_FOOD,
	SEARCHING,
	DELIVERING,
	WALKING
}
enum JOB{
	food,
	wood
	
}

@export var walk_speed = 5.0

var current_task=TASK.SEARCHING
var current_job=JOB.food
var run_once:=true
var spawn_point

var food_harvest_amount:=10
var food_hold_current:=0
var nearest_resource_object:Node3D


func _ready():
	_calc_new_resource_to_get()

func _physics_process(delta):
	$Label3D.text=str(TASK.find_key(current_task))

	match current_task:
		TASK.GETTING_FOOD:
			if run_once:
				run_once=false
				await (get_tree().create_timer(2.0).timeout)
				run_once=true
				#food_hold_current+=food_harvest_amount
				
				food_hold_current+=nearest_resource_object.resource_amount_generated
				
				nearest_resource_object._on_farmed()
				
					
				
				
				
				current_task=TASK.DELIVERING
		TASK.SEARCHING:
#			var resources=get_tree().get_nodes_in_group(str(JOB.find_key(current_job)))
#			#print(resources.size())
#			nearest_resource_object=resources[0]
#			for resource in resources:
#				if resource.global_position.distance_to(global_position)<nearest_resource_object.global_position.distance_to(global_position) and resource.current_worker_amount<resource.spots_for_workers:
#					nearest_resource_object=resource
#					nearest_resource_object.current_worker_amount+=1
#			navigation_agent.target_position=nearest_resource_object.global_position
			if !nearest_resource_object.is_farmable:
				#nearest_resource_object._on_max_farmed_reached()
				_calc_new_resource_to_get()
			else:
				_farm_own_resource()
			
			current_task=TASK.WALKING
		TASK.DELIVERING:
			var stocks=get_tree().get_nodes_in_group("stock")
			if stocks.is_empty():
				navigation_agent.target_position=spawn_point.global_position
				current_task=TASK.WALKING
			else:
				var nearest_stock=stocks[0]
				for stock in stocks:
					if stock.spawned:
						if stock.global_position.distance_to(global_position)<nearest_stock.global_position.distance_to(global_position):
							nearest_stock=stock
				navigation_agent.target_position=nearest_stock.get_node("SpawnPoint").global_position
				current_task=TASK.WALKING
		TASK.WALKING:
			
			if navigation_agent.is_navigation_finished():
				if food_hold_current==0:
					current_task=TASK.GETTING_FOOD
				else:
					match JOB.find_key(current_job):
						"food":GameManager.food+=food_hold_current
					food_hold_current=0
					current_task=TASK.SEARCHING
				return
			var target_pos=navigation_agent.get_next_path_position()
			var direction=global_position.direction_to(target_pos)
			velocity=direction*walk_speed
			move_and_slide()
func _farm_own_resource():
	navigation_agent.target_position=nearest_resource_object.global_position
		
func _calc_new_resource_to_get():
	var resources=get_tree().get_nodes_in_group(str(JOB.find_key(current_job)))
	nearest_resource_object=resources.pick_random()
	for resource in resources:
			if resource.global_position.distance_to(global_position)<nearest_resource_object.global_position.distance_to(global_position) and resource.current_worker_amount<resource.spots_for_workers and resource.is_farmable:
				resource.current_worker_amount+=1
				nearest_resource_object=resource
				
				
				
	navigation_agent.target_position=nearest_resource_object.global_position
	


