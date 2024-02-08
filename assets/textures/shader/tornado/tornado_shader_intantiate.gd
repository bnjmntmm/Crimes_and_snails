extends Node3D


var ready_to_move := false
var house_pos
var target_pos
var body_freed = false

var speed = 10
@onready var detect_house = $DetectHouse

var target = null

func _physics_process(delta):
	if ready_to_move and !body_freed:
		house_pos = target.position
		target_pos = (house_pos - position).normalized()
		global_position += target_pos * speed * delta
		


func _on_detect_house_body_entered(body):
	if body is StaticBody3D:
		body_freed = true
