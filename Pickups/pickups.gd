extends Node3D

class_name Pickup

# ---------------------------
var player_ref: CharacterBody3D
var cut_off_dist: float
var cut_off_dist_sqr: float

# ---------------------------

func pickup_fn(body: Player) -> void:
	queue_free()

func _ready() -> void:
	assert(player_ref and cut_off_dist and $Area3D)
	cut_off_dist_sqr = cut_off_dist * cut_off_dist
	$Area3D.body_entered.connect( func(body):
		if body is Player:
			pickup_fn(body))

func _physics_process(delta: float) -> void:
	if (player_ref.global_position - global_position).length_squared() > cut_off_dist_sqr:
		queue_free()
