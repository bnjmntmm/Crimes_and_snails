extends CharacterBody3D

@onready var navigation_agent = $NavigationAgent3D
@onready var navigation_region_3d = $"../NavigationRegion3D"



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


func _ready():
	pass

func _physics_process(delta):
	$Label3D.text=str(TASK.find_key(current_task))

	match current_task:
		TASK.GETTING_FOOD:
			if run_once:
				run_once=false
				await (get_tree().create_timer(2.0).timeout)
				run_once=true
				current_task=TASK.SEARCHING
		TASK.SEARCHING:
			var resources=get_tree().get_nodes_in_group(str(JOB.find_key(current_job)))
			print(resources.size())
			var nearest_resource_object=resources[0]
			for resource in resources:
				if resource.global_position.distance_to(global_position)<nearest_resource_object.global_position.distance_to(global_position):
					nearest_resource_object=resource
			navigation_agent.target_position=nearest_resource_object.global_position
			current_task=TASK.WALKING
		TASK.DELIVERING:
			var stocks=get_tree().get_nodes_in_group("stock")
			if stocks.is_empty():
				#navigation_agent.target_position=spawn_point.global_position
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
				match JOB.find_key(current_job):
					"food":GameManager.food+=5
				
				current_task=TASK.SEARCHING
				return
			var target_pos=navigation_agent.get_next_path_position()
			var direction=global_position.direction_to(target_pos)
			velocity=direction*walk_speed
			move_and_slide()
		
				
							
			
			
		

