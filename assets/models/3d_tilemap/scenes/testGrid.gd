extends Node3D

@onready var grid_map = $GridMap
var waterDip = FastNoiseLite.new()
var gridTopLayer = []
@export var noise_active = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if noise_active:
		randomize()
		waterDip.seed = randi()
		waterDip.frequency = 0.005
		
		var dist = (grid_map.get_used_cells().max()).x + (abs(grid_map.get_used_cells().min())).x
		var used_cells = grid_map.get_used_cells()
		for i in range(used_cells.size()):
			if used_cells[i].y == 1:
				gridTopLayer.append(used_cells[i])
				
		for i in range(gridTopLayer.size()):
			var cell = gridTopLayer[i]
			var waterNoiseAtPos = abs(waterDip.get_noise_2d(cell.x, cell.z))*10
			if waterNoiseAtPos < 0.3:
				grid_map.set_cell_item(Vector3i(cell),-1)
		
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
