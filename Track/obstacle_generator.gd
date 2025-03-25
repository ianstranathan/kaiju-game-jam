extends Node3D

signal track_grid_requested( fn: Callable)

@export_group("Environmental Obstacles")
@export_dir var obstacles_dir = "res://Track/Obstacles/Obstacle_Scenes/"
@export var obstacles_arr: Array = []
@export var oil_scene: PackedScene = preload("res://Environmentals/oil_spill.tscn")
#@export var test_obstacle_scene: PackedScene = preload("res://Track/Obstacles/Obstacle_Scenes/test_obstacle.tscn")
@export var debug_marker_scene: PackedScene = preload("res://Debug/debug_marker.tscn")
@export var nuclear_sphere_obstacle: PackedScene = preload("res://Pickups/Collectibles/nuclear_collectible.tscn")
@export var health_pickup_scene: PackedScene = preload("res://Pickups/health_pickup/health_pickup.tscn")
@export var energy_pickup_scene: PackedScene = preload("res://Pickups/weapons/basic/basic_weapon_pickup/basic_weapon_pickup.tscn")
@export var speed_boost_scene: PackedScene = preload("res://Environmentals/speed_boost/speed_boost.tscn")
@onready var single_tile_objects_arr = [oil_scene, 
										nuclear_sphere_obstacle,
										health_pickup_scene,
										energy_pickup_scene,
										speed_boost_scene]
										
@export var finish_portal: PackedScene = preload("res://Finish_Portal/finish_portal.tscn")
# ------------------------------------------------------------------------------
var make_portal = false
# ------------------------------------------------------------------------------
@onready var noise: FastNoiseLite = FastNoiseLite.new()
# ------------------------------------------------------------------------------
@export var grid_pos: Vector3 = Vector3.ZERO
@export var grid_size = Vector2.ZERO
var ground_height: float
var grid_scale: float
# ------------------------------------------------------------------------------
var cut_off_dist: float
var player_ref: CharacterBody3D

@onready var rand = RandomNumberGenerator.new()

func _ready() -> void:
	load_obstacle_scenes(obstacles_dir)
	rand.randomize()

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


func make_an_obstacle(obstacle_instance: Node3D,
					  pos: Vector3,
					  obstacle_height: float,
					  height_offset=0) -> void:
	# -- TODO: change this to be checking for obstacle rather than portal
	# -- refactor obstacle to have these or have a component that has these
	# -- what caching is going on!?!
	
	if !(obstacle_instance is FinishPortal):
		obstacle_instance.player_ref = player_ref
		obstacle_instance.cut_off_dist = cut_off_dist
	add_child(obstacle_instance)
	obstacle_instance.global_position = pos
	obstacle_instance.global_position.y = (height_offset + 1) * obstacle_height
	obstacle_instance.global_position.y += ground_height


#func make_a_box(pos: Vector3, k_loop_height_offset=0):
	#var box_instance = test_obstacle_scene.instantiate()
	#make_an_obstacle(box_instance, pos, box_instance.get_node("MeshInstance3D").mesh.size.y, k_loop_height_offset)


func make_object_per_tile(_instance: Node3D,
						  _pos_offset: Vector3,
						  grid_index: Vector2):
	#var _instance = _packed_scene.instantiate()
	var pos = grid_pos_from_offset(_pos_offset, grid_index)
	make_an_obstacle(_instance, pos, 0.)
	#var marker = debug_marker_scene.instantiate()
	#add_child(marker)
	#marker.global_position = pos

func get_rnd_indices_for_single_tile_objects() -> Array:
	var ret = []
	for i in range( single_tile_objects_arr.size()):
		ret.append(
			Vector2(rand.randi() % int(grid_size.x),
					rand.randi() % int(grid_size.y))
		)
	return ret

#var marker = debug_marker_scene.instantiate()
#add_child(marker)
func increment_grid_width_counter(_an_obstacle: Node3D, _grid_width_counter: int):
	return _grid_width_counter + _an_obstacle.grid_width


func increment_grid_length_counter(_an_obstacle: Node3D, _grid_length_counter: int):
	return _grid_length_counter + _an_obstacle.grid_length

var can_make_a_portal = true
func generate_obstacles(pos_offset: Vector3, noise_offset=0.0) -> void:
	# -- need to make sure these don't overlap
	# -- one of these per grid
	var grid_width_counter : int = 0
	var grid_length_counter: int = 0
	# -- we only want to make one portal
	# -- make_portal is affect by game state outside this object
	if !can_make_a_portal:
		return
	if make_portal:
		can_make_a_portal = false
		var finish_portal_instance = finish_portal.instantiate()
		make_object_per_tile(finish_portal_instance, 
							 pos_offset, 
							 Vector2(grid_size.x / 2, grid_size.y / 2))
	# if we're not making a portal, we're making obstacles
	else:
		# -- we have to generate before grid loop
		var single_item_indices = get_rnd_indices_for_single_tile_objects()
		
		for i in range(grid_size.x):
			if grid_width_counter == 0:
				for j in range( grid_size.y):
					if grid_length_counter == 0:
						# -- Single Items per Tile
						for ii in range(single_item_indices.size()):
							var index_vec = single_item_indices[ii]
							if index_vec.x == i and index_vec.y == j:
								var _object = single_tile_objects_arr[ii].instantiate()
								make_object_per_tile(_object, pos_offset, Vector2(i, j))
								continue
						var noise_sample = noise.get_noise_2d(i * 10. + noise_offset, j * 10. + noise_offset)
						
						# -- if we have grid space to add the item and it passes a noise test add the obstacle
						var pos = grid_pos_from_offset(pos_offset, Vector2(i, j))
						#if (pos - player_ref.global_position).length() < 5:
							#continue
						
						if noise_sample > rand.randf():
							var obstacle_instance = obstacles_arr.pick_random().instantiate()
							grid_width_counter  = increment_grid_width_counter(obstacle_instance, grid_width_counter)
							grid_length_counter = increment_grid_length_counter(obstacle_instance, grid_length_counter)
							# -- TODO: Here be a Magic number (0.2)
							# -- is the ground not right? I don't remember
							make_an_obstacle(obstacle_instance, pos, 0.3)
						# -- otherwise decrement the grid width counter to allow 
						# -- enough offset to make another obstacle
					else:
						grid_length_counter -= 1
			else:
				grid_width_counter -= 1.0
					

func load_obstacle_scenes(target_path: String) -> void:
	var dir = DirAccess.open(target_path)
	for scene_path in dir.get_files():
		var _file_path = target_path + "/" + scene_path
		#print("Loading terrian block scene: " + _file_path)
		obstacles_arr.append(load(_file_path))
	
# ----------------- DELETE BUFFER
#func make_the_object(pos: Vector3, height_offset=0):
	#var box = test_obstacle_scene.instantiate()
	#box.player_ref = player_ref
	#box.cut_off_dist = cut_off_dist
	#add_child(box)
	#box.global_position = pos
	#box.global_position.y = (height_offset + 1) * box.get_node("MeshInstance3D").mesh.size.y
	#box.global_position.y += ground_height
