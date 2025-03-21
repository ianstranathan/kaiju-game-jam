extends Node3D

var player_ref: CharacterBody3D
var cut_off_dist: float
var cut_off_dist_sqr: float
@export var DEBUG: bool = false
func _ready() -> void:
	if !DEBUG:
		assert(player_ref and cut_off_dist)
		cut_off_dist_sqr = cut_off_dist * cut_off_dist

	$Area3D.body_entered.connect(func(body):
		if body is Player:
			queue_free())

func _physics_process(delta: float) -> void:
	if !DEBUG:
		if (player_ref.global_position - global_position).length_squared() > cut_off_dist_sqr:
			queue_free()
			
