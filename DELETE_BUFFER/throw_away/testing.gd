extends Node3D

@onready var radius = global_position.z
var _time = 0.0

func _physics_process(delta: float) -> void:
	_time += delta
	global_position = radius * Vector3(sin(_time), 0., cos(_time))
