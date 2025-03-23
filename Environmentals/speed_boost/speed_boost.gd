extends Node3D

var player_ref: CharacterBody3D
var cut_off_dist: float
var cut_off_dist_sqr: float

func _ready() -> void:
	assert(player_ref and cut_off_dist and $Area3D)
	cut_off_dist_sqr = cut_off_dist * cut_off_dist
	$Area3D.body_entered.connect(func(body):
		if body is Player:
			body.acceleration_curve( "Speed Boost"))

func _physics_process(delta: float) -> void:
	if (player_ref.global_position - global_position).length_squared() > cut_off_dist_sqr:
		queue_free()
