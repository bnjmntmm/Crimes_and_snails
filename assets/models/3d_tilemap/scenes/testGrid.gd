extends Node3D

@onready var grid_map = $GridMap
var gridTopLayer = []
@export var noise_active = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if noise_active:
		var dist = (grid_map.get_used_cells().max()).x + (abs(grid_map.get_used_cells().min())).x
		var texture = NoiseTexture2D.new()
		texture.height = dist
		texture.width = dist
		texture.noise = FastNoiseLite.new()
		texture.noise.seed= randi()%10+1
		await texture.changed
		var image = texture.get_image()
		var data = image.get_data()
		var norm_data = normalize_array(data)
		
		var used_cells = grid_map.get_used_cells()
		for i in range(used_cells.size()):
			if used_cells[i].y == 1:
				gridTopLayer.append(used_cells[i])
		for i in range(gridTopLayer.size()):
			var x = gridTopLayer[i].x
			var z = gridTopLayer[i].z
			if norm_data[i] < 0.3:
				grid_map.set_cell_item(Vector3(x,1,z),-1)		
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func normalize_array(array: Array):
	var minVal = array.min()
	var maxVal = array.max()
	for i in range(0,array.size()):
		array[i] = snapped(remap(array[i], minVal,maxVal, 0.0, 1.0),0.001)
	return array
