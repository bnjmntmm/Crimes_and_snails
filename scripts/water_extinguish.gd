extends Node3D

@onready var gpu_particles_3d = $GPUParticles3D


func set_emitting(value):
	gpu_particles_3d.set_emitting(value)

func is_emitting():
	return gpu_particles_3d.is_emitting()
