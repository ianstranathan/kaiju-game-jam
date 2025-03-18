extends Node3D

signal track_grid_requested( fn: Callable)

@export var test_obstacle_scene: PackedScene = preload("res://Track/Obstacles/test_obstacle.tscn")

@onready var noise: FastNoiseLite = FastNoiseLite.new()

# TODO: scaling tracks offsets the ground
@export var grid_pos: Vector3 = Vector3.ZERO
@export var grid_size = Vector2.ZERO
var ground_height: float
var grid_scale: float

	
var cut_off_dist: float
var player_ref: CharacterBody3D
func set_grid(_grid: Vector4):
	# _grid: # e.g. (2.0, 0.1, 2.0, 7.0)
	grid_scale    = _grid.w
	grid_size.x   = grid_scale * _grid.x
	grid_size.y   = grid_scale * _grid.z
	ground_height = grid_scale * _grid.y / 2.0
	
	generate_obstacles(Vector3.ZERO)

func grid_pos_from_offset(offset: Vector3, grid_indices: Vector2):
	# -- tile pos + grid pos
	var pos = offset - Vector3(grid_size.x / 2, 0., grid_size.y / 2)
	pos += Vector3(grid_indices.x, ground_height, grid_indices.y)
	return pos

func make_the_object(pos: Vector3, height_offset=0):
	var box = test_obstacle_scene.instantiate()
	box.player_ref = player_ref
	box.cut_off_dist = cut_off_dist
	add_child(box)
	box.global_position = pos
	box.global_position.y = (height_offset + 1) * box.get_node("MeshInstance3D").mesh.size.y
	box.global_position.y += ground_height

#@export var xz_noise_threshold := 0.2
#@export var y_noise_threshold := 0.0
func generate_obstacles(pos_offset: Vector3, noise_offset=0.0):
	for i in range(grid_size.x):
		for j in range( grid_size.y):
			var noise_sample = noise.get_noise_2d(i * 10. + noise_offset, j * 10. + noise_offset)
			if noise_sample > randf():
				var pos = grid_pos_from_offset(pos_offset, Vector2(i, j))
				make_the_object( pos )
				for k in range(4):
					if noise.get_noise_1d( (i + j + k) * 10.0  + noise_offset) > 0.5 * randf():
						var height_pos = Vector3(pos.x, k, pos.z)
						make_the_object( height_pos, k)
