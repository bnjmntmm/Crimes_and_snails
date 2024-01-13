extends Node3D

@onready var navigation_region_3d = $"../Grid/NavigationRegion3D"
# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("custom_setup")


func custom_setup():
	GameManager.map = NavigationServer3D.map_create()
	NavigationServer3D.map_set_up(GameManager.map, Vector3.UP)
	NavigationServer3D.map_set_active(GameManager.map, true)
	
	#new nav region and add to map
	var region : RID = NavigationServer3D.region_create()
	NavigationServer3D.region_set_transform(region, Transform3D())
	NavigationServer3D.region_set_map(region, GameManager.map)
	
	#add the navigation mesh to the region
	var new_navigation_mesh : NavigationMesh = NavigationMesh.new()
	new_navigation_mesh = navigation_region_3d.navigation_mesh
	NavigationServer3D.region_set_navigation_mesh(region, new_navigation_mesh)
	await get_tree().physics_frame
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
