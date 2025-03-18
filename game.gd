extends Node3D

@export var fog_dist := 100.0
@export var obstacle_noise_seed := 10.0
func _ready() -> void:
	# -- using player in splash screen, so w/e
	$Player.start_game()
	# TODO: wrap this all up more cleanly please
	$ObstacleGenerator.cut_off_dist = fog_dist
	$ObstacleGenerator.player_ref = $Player
	# -- the track emits its dim -> connects to Obstacle generator
	$ObstacleGenerator.set_grid($TrackGenerator.track_dims())
	$TrackGenerator.tile_made.connect( func(_pos: Vector3):
		$ObstacleGenerator.generate_obstacles(_pos, randf() * obstacle_noise_seed))
	start_game()
	
func start_game():
	$TrackGenerator.init_tiles()
