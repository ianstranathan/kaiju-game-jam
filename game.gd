extends Node3D

@export var fog_dist := 100.0
@export var obstacle_noise_seed := 10.0
func _ready() -> void:
	# -- using player in splash screen, so w/e
	$Player.start_game()
	$Player.health_changed.connect( func( ratio: float):
		$CanvasLayer/Hud.update_health( ratio ))
		
	# TODO: wrap this all up more cleanly please
	$ObstacleGenerator.cut_off_dist = fog_dist
	$ObstacleGenerator.player_ref = $Player
	# -- the track emits its dim -> connects to Obstacle generator
	$ObstacleGenerator.set_grid($TrackGenerator.track_dims())
	$TrackGenerator.tile_made.connect( func(_pos: Vector3):
		$ObstacleGenerator.generate_obstacles(_pos, randf() * obstacle_noise_seed))
	
	# -- connecting the fireball shooting to the vfx container to silo
	# -- the effects for the larger scene tree (main) so we pause or restart
	# -- without weird artifacts
	$Kaiju.fireball_shot.connect( func(_fireball_instance, callback_fn: Callable):
		# add decal to VFX container to not make it persistent between runs
		_fireball_instance.exploded.connect( func(_decal_instance: Decal, callback_fn: Callable):
			$VFX_container.add_child(_decal_instance)
			# -- closure around instance -> position correctly
			callback_fn.call())
		$VFX_container.add_child(_fireball_instance)
		# -- closure around instance -> position correctly
		callback_fn.call())
	start_game()

@onready var HUD = $CanvasLayer/Hud
@onready var extraction_timer = $ExtractionTimer
func start_game():
	extraction_timer.start()
	$TrackGenerator.init_tiles()

#func _physics_process(delta: float) -> void:
#	HUD.update_timer(extraction_timer.time_left / extraction_timer.wait_time)
