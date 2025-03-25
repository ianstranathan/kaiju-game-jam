extends Node3D

var splat_textures_arr: Array            = []
@export_dir var splat_textures_path = "res://Assets/Textures/Splats/"

# TODO
var player_ref: CharacterBody3D
var cut_off_dist: float
var cut_off_dist_sqr: float

# -- TODO
# -- It's stupid to have a unique shader for each spill
# -- Textures are popping in and out because the shared resource
# -- -> just pick a texture and call it a day
#func load_terrain_scenes(target_path: String) -> void:
	#var dir = DirAccess.open(target_path)
	#for scene_path in dir.get_files():
		#var _file_path = target_path + "/" + scene_path
		#if _file_path.split(".")[-1] == "png":
			#splat_textures_arr.append(load(_file_path))

var tex: CompressedTexture2D
func _ready() -> void:
	# TODO
	cut_off_dist_sqr = cut_off_dist * cut_off_dist
#
	global_rotation.y = randf() * TAU
	#load_terrain_scenes(splat_textures_path)
	#$MeshInstance3D.material_override.set_shader_parameter("texture_albedo", splat_textures_arr.pick_random())

	$Area3D.body_entered.connect(func(body):
		if body is Player:
			body.acceleration_curve( "Oil", true))

	$Area3D.body_exited.connect(func(body):
		if body is Player:
			body.acceleration_curve( "Oil", false))

# TODO
func _physics_process(_delta: float) -> void:
	if player_ref:
		if (player_ref.global_position - global_position).length_squared() > cut_off_dist_sqr:
			queue_free()
