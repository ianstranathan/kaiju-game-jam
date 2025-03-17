extends Area3D

signal last_particle_done

func _ready() -> void:
	$smoke.finished.connect( func(): emit_signal("last_particle_done"))
