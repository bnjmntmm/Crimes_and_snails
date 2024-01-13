extends CharacterBody3D

@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D
@onready var pov_camera = Camera3D.new()
@onready var main_camera = get_viewport().get_camera_3d()
@onready var npc_menu = $npc_menu





enum TASK{
	GETTING_FOOD,
	SEARCHING,
	DELIVERING,
	WALKING,
	POV_MODE
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

var mouse_sensitivity = 0.002
var food_harvest_amount:=10
var food_hold_current:=0
var nearest_resource_object:Node3D

# Path
var path = []


func _ready():
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	if JOB.find_key(current_job) == "wood":
		if GameManager.tree_array.size() > 0:
			var randomTree = GameManager.tree_array.pick_random()
			#navigation_agent.target_position = randomTree.global_position
			path = NavigationServer3D.map_get_path(GameManager.map, global_position, randomTree.global_position, true)
			path.remove_at(0)
			set_process(true)
	elif JOB.find_key(current_job)== "food":
		if GameManager.bush_array.size() > 0:
			var randomBush = GameManager.bush_array.pick_random()
			#navigation_agent.target_position = randomBush.global_position
			path = NavigationServer3D.map_get_path(GameManager.map, global_position, randomBush.global_position, true)
			path.remove_at(0)
			set_process(true)
	add_child(pov_camera)
#	_calc_new_resource_to_get()
	GameManager.population+=1

func _process(delta):
	var walk_distance = 20*delta
	move_along_path(walk_distance)
	

func move_along_path(distance):
	var last_point = self.position
	while path.size():

		var distance_between_points = last_point.distance_to(path[0])
		if distance <= distance_between_points:
			self.position = last_point.lerp(path[0], distance/ distance_between_points)
			return
		distance -= distance_between_points
		last_point = path[0]
		path.remove_at(0)
	self.position = last_point
	set_process(false)
	#walk back to center?

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pov_camera.rotate_x(-event.relative.y * mouse_sensitivity)
		# Clamps the POV camera's x rotation to avoid flipping over.
		pov_camera.rotation.x = clampf(pov_camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _physics_process(delta):
	#if navigation_agent.is_navigation_finished():
	#	print("nav done")
	#	return
	var next_path_position : Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * walk_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
#	$Label3D.text=str(TASK.find_key(current_task))
#
#	match current_task:
#		TASK.POV_MODE:
#			if Input.is_action_just_released("esc"):
#				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#				pov_camera.current = false
#				main_camera.current = true
#				GameManager.current_state = GameManager.State.PLAY
#				current_task = TASK.SEARCHING
#			var input_dir = Input.get_vector("left", "right", "forward", "backward")
#			var walk_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
#			if walk_direction:
#				velocity.x = walk_direction.x * walk_speed
#				velocity.z = walk_direction.z * walk_speed
#				move_and_slide()
#		TASK.GETTING_FOOD:
#			if run_once:
#				run_once=false
#				await (get_tree().create_timer(2.0).timeout)
#				run_once=true
#				if GameManager.current_state == GameManager.State.POV_MODE:
#					return
#				#food_hold_current+=food_harvest_amount
#
#				#print(nearest_resource_object.resource_amount_generated)
#				food_hold_current+=nearest_resource_object.resource_amount_generated
#
#				nearest_resource_object._on_farmed()
#
#
#
#
#
#				current_task=TASK.DELIVERING
#		TASK.SEARCHING:
##			var resources=get_tree().get_nodes_in_group(str(JOB.find_key(current_job)))
##			#print(resources.size())
##			nearest_resource_object=resources[0]
##			for resource in resources:
##				if resource.global_position.distance_to(global_position)<nearest_resource_object.global_position.distance_to(global_position) and resource.current_worker_amount<resource.spots_for_workers:
##					nearest_resource_object=resource
##					nearest_resource_object.current_worker_amount+=1
##			navigation_agent.target_position=nearest_resource_object.global_position
#			if !nearest_resource_object.is_farmable:
#				#nearest_resource_object._on_max_farmed_reached()
#				_calc_new_resource_to_get()
#			else:
#				_farm_own_resource()
#
#			current_task=TASK.WALKING
#		TASK.DELIVERING:
#			var stocks=get_tree().get_nodes_in_group("stock")
#			if stocks.is_empty():
#				navigation_agent.target_position=spawn_point.global_position
#				current_task=TASK.WALKING
#			else:
#				var nearest_stock=stocks[0]
#				for stock in stocks:
#					if stock.spawned:
#						if stock.global_position.distance_sqaured_to(global_position)<nearest_stock.global_position.distance_squared_to(global_position):
#							nearest_stock=stock
#				navigation_agent.target_position=nearest_stock.get_node("SpawnPoint").global_position
#				current_task=TASK.WALKING
#		TASK.WALKING:
#
#			if navigation_agent.is_navigation_finished():
#				if food_hold_current==0:
#					current_task=TASK.GETTING_FOOD
#				else:
#					match JOB.find_key(current_job):
#						"food":GameManager.food+=food_hold_current
#					food_hold_current=0
#					current_task=TASK.SEARCHING
#				return
#			var target_pos=navigation_agent.get_next_path_position()
#			var direction=global_position.direction_to(target_pos)
#			velocity=direction*walk_speed
#			move_and_slide()
#
#func _farm_own_resource():
#	navigation_agent.target_position=nearest_resource_object.global_position
#
#func _calc_new_resource_to_get():#
#	var resources = get_tree().get_nodes_in_group(str(JOB.find_key(current_job)))
#	nearest_resource_object=resources.pick_random()
#	var nearest_resource_dist = nearest_resource_object.global_position.distance_squared_to(global_position)
#	for resource in resources:
#		var resourceGlobalPos : Vector3 = resource.global_position
#		if not resource.is_farmable or resource.current_worker_amount  >= resource.spots_for_workers:
#			continue
#		var resource_dist = resource.global_position.distance_squared_to(global_position)
#		if resource_dist < nearest_resource_dist:
#			nearest_resource_object = resource
#			nearest_resource_dist = resource_dist
#	if not nearest_resource_object.is_farmable:
#		pass
#		#no resources left
#	nearest_resource_object.current_worker_amount +=1
#	navigation_agent.target_position = nearest_resource_object.global_position
#
	
	
	## OLD
#	var resources=get_tree().get_nodes_in_group(str(JOB.find_key(current_job)))
#	nearest_resource_object=resources.pick_random()
#	for resource in resources:
#			if resource.global_position.distance_squared_to(global_position)<nearest_resource_object.global_position.distance_squared_to(global_position) and resource.current_worker_amount<resource.spots_for_workers and resource.is_farmable:
#				resource.current_worker_amount+=1
#				nearest_resource_object=resource
#
#
#
#	navigation_agent.target_position=nearest_resource_object.global_position
#

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()


func _on_clicked(camera, event, position, normal, shape_idx):
	if Input.is_action_just_released("left_mouse_down") and not GameManager.opened_npc_menu:
		GameManager.opened_npc_menu = true
		npc_menu.set_position(get_viewport().get_mouse_position())
		npc_menu.visible = true



func _on_close_button_pressed():
	npc_menu.visible = false
	GameManager.opened_npc_menu = false


func _on_pov_mode_pressed():
		npc_menu.visible = false
		GameManager.opened_npc_menu = false
		main_camera.current = false
		pov_camera.current = true
		GameManager.current_state = GameManager.State.POV_MODE
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		current_task = TASK.POV_MODE
