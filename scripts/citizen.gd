extends CharacterBody3D

# 01. @onready variables
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var pov_camera = Camera3D.new()
@onready var main_camera = get_viewport().get_camera_3d()
@onready var npc_menu = $npc_menu
@onready var current_job_value = $npc_menu/current_job_value
@onready var audio_stream_player = $AudioStreamPlayer
@onready var animation_tree = $citizen_root/AnimationTreeNormalCit
@onready var extinguish_timer = $ExtinguishTimer


# 02. Constants and Preloads
var waterParticlesPrefab = preload("res://assets/particles/water_extinguish.tscn")
var blue_skin = preload("res://assets/char_model/blue_skin.tres")
var yellow_skin = preload("res://assets/char_model/yellow_skin.tres")
var orange_skin = preload("res://assets/char_model/orange_skin.tres")
var water_progressPrefab = preload("res://scenes/utils/water_extinguish_timer.tscn")

var skin_array = [blue_skin, yellow_skin, orange_skin]

# 03. @onready nodes
@onready var body := $citizen_root/Citizen/Skeleton3D/Body
@onready var citizen_root = $citizen_root
@onready var criminalclothing = $citizen_root/Citizen/Skeleton3D/Criminalclothing
@onready var criminalhat = $citizen_root/Citizen/Skeleton3D/Criminalhat
@onready var normalclothing = $citizen_root/Citizen/Skeleton3D/Normalclothing
@onready var normalhat = $citizen_root/Citizen/Skeleton3D/Normalhat

# 04. Enums
enum TASK{
	GETTING_FOOD,
	SEARCHING,
	DELIVERING,
	WALKING,
	POV_MODE,
	RIOT
}
enum JOB{
	food,
	wood
}

# 05. @export variables
@export var walk_speed = 5.0
@export var food_consumption = 10.0

# 06. Public variables
var current_task = TASK.SEARCHING
var current_job = JOB.food
var run_once := true
var spawn_point
var is_collecting := false

var mouse_sensitivity = 0.002

var resource_hold_current := 0
var nearest_resource_object:Node3D

var waterParticles : Node3D
var waterProgressNode : Control
var waterProgress : ProgressBar
var waterLabel : Label
#this is for the water
var currentHouse = null

var anim_pos_dict = {
	"melking" : Vector2(0,1.1),
	"walking" : Vector2(1,0),
	"working" : Vector2(0,-1.1),
	"strutting": Vector2(-1,0),
	"busy" : Vector2(0,0)
}
#Path
var path = []
var allowWater = false


#for the sabotage walking
var is_disguised
var sabotageHouse
var gotToSabotageHouse = false
signal reachedSabotageHouse
var runOnceSabotage = true



func _ready():
	randomize()
	animation_tree.active = true
	body.set_surface_override_material(0, skin_array.pick_random())
	
	
	#change_to_criminal()
	
	current_job=JOB.find_key(randi_range(0,1))
	match current_job:
		"food":current_job_value.text="Farmer"
		"wood":current_job_value.text="Lumberjack"
	
	
	
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	if current_job == "wood":
		if GameManager.tree_array.size() > 0:
			var randomTree = GameManager.tree_array.pick_random()
			while !is_instance_valid(randomTree):
				randomTree = GameManager.tree_array.pick_random()
			navigation_agent.target_position = randomTree.global_position
			set_process(true)
	elif current_job == "food":
		if GameManager.bush_array.size() > 0:
			var randomBush = GameManager.bush_array.pick_random()
			while !is_instance_valid(randomBush):
				randomBush = GameManager.bush_array.pick_random()
			navigation_agent.target_position = randomBush.global_position
			set_process(true)
	pov_camera.position = Vector3(0,0.6,0)
	add_child(pov_camera)
	pov_camera.current = false
	waterParticles = waterParticlesPrefab.instantiate()
	waterProgressNode = water_progressPrefab.instantiate()
	waterProgress = waterProgressNode.get_child(0)
	waterLabel = waterProgressNode.get_child(1)
	pov_camera.add_child(waterParticles)
	waterParticles.position = pov_camera.position + Vector3(0.5,-0.6,0)
	
	waterProgress.visible = false
	pov_camera.add_child(waterProgressNode)
	


func move_along_path():
	if navigation_agent.is_navigation_finished():
		if  resource_hold_current==0:
			current_task=TASK.GETTING_FOOD
		else:
			match current_job:
				"food":GameManager.food+=resource_hold_current
				"wood":GameManager.wood+=resource_hold_current
			resource_hold_current=0
			current_task=TASK.SEARCHING
		return
	var next_path_position : Vector3 = navigation_agent.get_next_path_position()
	#var angleToNextPoint =  citizen_root.global_position.angle_to(next_path_position)
	var lookAtPos := next_path_position
	citizen_root.look_at(Vector3(lookAtPos.x, 1.53,lookAtPos.z), Vector3(0,1,0), true)
	#citizen_root.look_at(next_path_position, Vector3(0,1,0), true)
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * walk_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	#walk back to center?

func move_towards_sabotage_house():
	#print(sabotageHouse)
	gotToSabotageHouse = false
	if navigation_agent.is_navigation_finished():
		if runOnceSabotage:
			runOnceSabotage = false
			gotToSabotageHouse = true
			update_animation_tree(anim_pos_dict["working"])
			await get_tree().create_timer(5).timeout
			reachedSabotageHouse.emit()
			runOnceSabotage = true
			change_to_normal()
			current_task = TASK.SEARCHING
	
	if not navigation_agent.is_target_reachable():
		print("stuck?")
	var next_path_position : Vector3 = navigation_agent.get_next_path_position()
	var lookAtPos := next_path_position
	citizen_root.look_at(Vector3(lookAtPos.x, 1.53,lookAtPos.z), Vector3(0,1,0), true)
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * walk_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
			
func _process(delta):
	if pov_camera.current == true:
		$citizen_root.visible = false
	else:
		$citizen_root.visible = true

	

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and current_task == TASK.POV_MODE:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pov_camera.rotate_x(-event.relative.y * mouse_sensitivity)
		# Clamps the POV camera's x rotation to avoid flipping over.
		pov_camera.rotation.x = clampf(pov_camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	if event.is_action_pressed("left_mouse_down") and GameManager.current_state == GameManager.State.POV_MODE and current_task == TASK.POV_MODE:
		var raycast_result  = execute_raycast(event.position, pov_camera)
		if raycast_result != null:
			var house = raycast_result.collider
			if house.isBurning:	
				allowWater = true
				extinguish_timer.start()
				currentHouse = house
				waterProgress.visible = true
				
#				house.sabotageType.fire_stopped(house)
#				house.isBurning = false#
#				print("brand gelöscht. Super gemacht")

func _physics_process(delta):
	if Input.is_action_pressed("left_mouse_down") and current_task == TASK.POV_MODE and allowWater:
		waterParticles.set_emitting(true)
		waterProgress.value = calcPercentage()
		if extinguish_timer.is_stopped() and is_instance_valid(currentHouse):
			waterProgress.value = 0
			waterProgress.visible = false
			waterLabel.visible = false
			currentHouse.sabotageType.fire_stopped(currentHouse) 
			allowWater = false
			waterParticles.set_emitting(false)
			GameManager.sabotages_stopped += 1
	if Input.is_action_just_released("left_mouse_down") and current_task == TASK.POV_MODE and allowWater:
		waterParticles.set_emitting(false)
		extinguish_timer.stop()
		waterProgress.visible = false
		waterProgress.value = 0
		
		
	match current_task:
		TASK.SEARCHING:
			update_animation_tree(anim_pos_dict["busy"])
			if current_job == "food":
				calc_new_resource_to_get(GameManager.bush_array)
			if current_job == "wood":
				calc_new_resource_to_get(GameManager.tree_array)
	
		TASK.WALKING:
			move_along_path()
			update_animation_tree(anim_pos_dict["walking"])
		TASK.GETTING_FOOD:
			if run_once:
				run_once = false
				var randomInt = randi_range(0,1)
				if randomInt == 1:
					update_animation_tree(anim_pos_dict["working"])
				else:
					update_animation_tree(anim_pos_dict["melking"])
				if is_instance_valid(nearest_resource_object):
					citizen_root.look_at(nearest_resource_object.global_position, Vector3(0,1,0), true)
					is_collecting = true
					await (get_tree().create_timer(2.0).timeout)
					is_collecting = false
					update_animation_tree(anim_pos_dict["walking"])
					run_once = true
		#			if pov_camera.current == true:
		#				current_task= TASK.POV_MODE
		#				return
					resource_hold_current+=nearest_resource_object.resource_amount_generated
					nearest_resource_object._on_farmed()
					current_task = TASK.DELIVERING
				else:
					current_task = TASK.SEARCHING
		TASK.DELIVERING:
			if GameManager.stock_array.is_empty():
				navigation_agent.target_position = spawn_point.global_position
				current_task = TASK.WALKING
			else:
				var nearest_stock
				for i in range(len(GameManager.stock_array)):
					nearest_stock = GameManager.stock_array[i]
					if is_instance_valid(nearest_stock):
						break
				for stock in GameManager.stock_array:
					if is_instance_valid(nearest_stock) and is_instance_valid(stock):
						if stock.spawned:
							if stock.global_position.distance_squared_to(global_position)<nearest_stock.global_position.distance_squared_to(global_position):
								nearest_stock=stock
				navigation_agent.target_position=nearest_stock.get_node("SpawnPoint").global_position
				current_task=TASK.WALKING
		TASK.POV_MODE:
			animation_tree.active = false
			waterLabel.visible = true
			if Input.is_action_just_pressed("esc"):
				pov_camera.current = false
				waterLabel.visible = false
				audio_stream_player.play()
				animation_tree.active = true
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

				main_camera.current = true
				GameManager.current_state = GameManager.State.PLAY
				if  resource_hold_current==0:
					current_task = TASK.SEARCHING
				else:
					current_task = TASK.DELIVERING
			var input_dir = Input.get_vector("left", "right", "forward", "backward")
			var walk_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			if walk_direction:
				velocity.x = walk_direction.x * walk_speed
				velocity.z = walk_direction.z * walk_speed
				move_and_slide()

		TASK.RIOT:
			if is_instance_valid(sabotageHouse):
				if navigation_agent.target_position != sabotageHouse.sabotage_point.global_position:
					navigation_agent.target_position = sabotageHouse.sabotage_point.global_position
					change_to_criminal()
				move_towards_sabotage_house()
			else:
				reset_npc()
		
		
		
func calcPercentage():
	var extinguishTime = 3
	var percentage = (float(extinguish_timer.time_left) / float(extinguishTime)) * 100
	return snapped(percentage, 0.1)

func execute_raycast(event_position, camera : Camera3D):
	var raycastFrom = camera.project_ray_origin(event_position)
	var raycastTo = raycastFrom + camera.project_ray_normal(event_position) * 20
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = raycastFrom
	ray_query.to = raycastTo
	ray_query.collide_with_areas = false
	ray_query.collide_with_bodies = true
	var raycast_result = space.intersect_ray(ray_query)
	if !raycast_result.is_empty():
		if raycast_result.collider.is_in_group("building") or raycast_result.collider.is_in_group("stock"):
			return raycast_result


func calc_new_resource_to_get(resources: Array):
	nearest_resource_object = resources.pick_random()
	var nearest_resource_distance=nearest_resource_object.global_position.distance_squared_to(global_position)
	for resource in resources:
		if !resource.is_farmable or resource.current_worker_amount >= resource.spots_for_workers:
			continue
		else:
			var resource_distance=resource.global_position.distance_squared_to(global_position)
			if resource_distance<nearest_resource_distance:
				nearest_resource_object=resource
				nearest_resource_distance=resource_distance
	nearest_resource_object.current_worker_amount+=1
	navigation_agent.target_position = nearest_resource_object.global_position
	current_task=TASK.WALKING


func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()

func _on_clicked(camera, event, position, normal, shape_idx):
	if not is_disguised:
		if Input.is_action_just_released("left_mouse_down"):
			GameManager.opened_npc_menu = true
			#npc_menu.set_position(get_viewport().get_mouse_position())
			npc_menu.visible = true



func _on_close_button_pressed():
	npc_menu.visible = false
	GameManager.opened_npc_menu = false


func _on_pov_mode_pressed():
	if !is_collecting:
		audio_stream_player.play()
		npc_menu.visible = false
		GameManager.opened_npc_menu = false
		main_camera.current = false
		pov_camera.current = true
		navigation_agent.target_position = global_position
		navigation_agent.get_next_path_position()
		GameManager.current_state = GameManager.State.POV_MODE
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		current_task = TASK.POV_MODE
		GameManager.npc_in_charge = self



func _on_job_wood_button_down():
	current_job=JOB.find_key(1)
	current_job_value.text="Lumberjack"
	


func _on_job_food_button_down():
	current_job=JOB.find_key(0)
	current_job_value.text="Farmer"

func update_animation_tree(newPos : Vector2):
	animation_tree["parameters/BlendSpace/blend_position"] = newPos


func change_to_criminal():
	is_disguised = true
	criminalclothing.visible = true
	criminalhat.visible = true
	normalclothing.visible = false
	normalhat.visible = false
func change_to_normal():
	is_disguised = false
	criminalclothing.visible = false
	criminalhat.visible = false
	normalclothing.visible = true
	normalhat.visible = true

func reset_npc():
	change_to_normal()
	navigation_agent.target_position = global_position
	current_task = TASK.SEARCHING


func _on_eat_timer_timeout():
	GameManager.food -= food_consumption
