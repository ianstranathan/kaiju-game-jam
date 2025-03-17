extends Node3D

@export var player_reference: CharacterBody3D
@export var kaiju_reference:  CharacterBody3D

var terrain_tiles_arr: Array            = [] # -- references to track scenes
var terrain_belt: Array[Node3D] = [] # -- container for track
@export var terrain_velocity: float = 10.0
@export_dir var terrain_tiles_path = "res://Track/RunnerTracks/"

@export_group("Tiles")
@export var initial_tile_scene: Node3D
# -- this is assuming movement in the x direction (or track is oriented
# -- such that the thinnest part in in x
@onready var tile_len = initial_tile_scene.scale.x * initial_tile_scene.get_track_width()
@export var num_tiles_in_front :int = 4
@export var num_tiles_in_back :int = 4
@onready var num_tiles_to_make := how_many_tiles_to_make_between_kaiju()

func _ready() -> void:
	assert( initial_tile_scene )
	assert( kaiju_reference)
	assert( player_reference )
	
	load_terrain_scenes(terrain_tiles_path)
	init_tiles()
	
	initial_tile_scene.queue_free()
	#for child in get_children():
		#print(child.global_position)

func _physics_process(delta: float) -> void:
	# -- closest tile is the last one in array
	if abs(player_reference.global_position.x - terrain_belt[-1].global_position.x) <= 2.0 * tile_len:
		increment_belt()

func init_tiles():
	# arr[0] most forward; arr[-1] most behind
	var n = num_tiles_in_front + num_tiles_in_back
	# -- moves domain to be in front of origin
	var initial_offset := Vector3(num_tiles_in_front * tile_len, 0., 0.)
	for i in range(n, 0, -1):
		#var index = num_tiles_in_front - i
		add_a_tile_to_belt( Vector3(-i * tile_len, 0., 0.) + initial_offset)


func load_terrain_scenes(target_path: String) -> void:
	var dir = DirAccess.open(target_path)
	for scene_path in dir.get_files():
		var _file_path = target_path + "/" + scene_path
		#print("Loading terrian block scene: " + _file_path)
		terrain_tiles_arr.append(load(_file_path))


func how_many_tiles_to_make_between_kaiju() -> int:
	var d = (kaiju_reference.global_position - global_position).x
	return abs(d / tile_len)


func add_a_tile_to_belt(pos: Vector3):
	var rnd_tile = terrain_tiles_arr.pick_random().instantiate()
	add_child(rnd_tile)
	terrain_belt.append(rnd_tile)
	rnd_tile.global_position = pos

@onready var belt_size :int
func increment_belt():
	if belt_size:
		assert(terrain_belt.size() == belt_size) # -- no oopsie infinite growth
	else:
		belt_size = terrain_belt.size()
	# -- closest tile is the last one
	terrain_belt.pop_front().queue_free()
	add_a_tile_to_belt( terrain_belt[-1].global_position + Vector3(tile_len, 0., 0.))
