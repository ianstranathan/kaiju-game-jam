extends Node3D

class_name CutOff

var player_ref: CharacterBody3D
var cut_off_dist: float
var cut_off_dist_sqr: float

func _ready() -> void:
	assert(player_ref and cut_off_dist)
	cut_off_dist_sqr = cut_off_dist * cut_off_dist

func _physics_process(delta: float) -> void:
	if (player_ref.global_position - global_position).length_squared() > cut_off_dist_sqr:
		queue_free()
