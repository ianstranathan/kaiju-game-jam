extends Node3D

var player_ref: CharacterBody3D
var cut_off_dist: float
var cut_off_dist_sqr: float
@export var grid_width: int
@export var grid_length: int
@export var askew = false
@export var DEBUG: bool = false

func _ready() -> void:
	rotation.y += 90.0
	print(name)
	if askew:
		global_rotation.x += Utils.rand_gen.randf() * PI / 8
	#assert(player_ref)
	assert(cut_off_dist)
	assert(grid_width)
	cut_off_dist_sqr = cut_off_dist * cut_off_dist

func _physics_process(delta: float) -> void:
	if (player_ref.global_position - global_position).length_squared() > cut_off_dist_sqr:
			queue_free()
