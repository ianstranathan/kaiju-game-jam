extends Node3D


# -- needs to be able to give a weapon
var _weapon_scene
@onready var _skin = $MeshInstance3D

func _ready() -> void:
	$Area3D.body_entered.connect( func(body):
		if body is Player:
			body.pickup(_weapon_scene))
	_skin.global_rotation = rnd_rot()
	start_infin_tweening_rotation()


func rnd_rot() -> Vector3:
	return PI * Vector3(randf(), randf(), randf())
	#var noise_x = Utils.noise_sampler.get_noise_1d(_skin.global_rotation.x)
	#var noise_z = Utils.noise_sampler.get_noise_1d(_skin.global_rotation.z)
	#var noise_y = Utils.noise_sampler.get_noise_1d(_skin.global_rotation.y)
	#var rnd = randf()
	#return PI * Vector3(rnd, rnd, rnd) 


func start_infin_tweening_rotation():
	var tween = get_tree().create_tween()
	tween.tween_property($MeshInstance3D, "global_rotation", global_rotation + rnd_rot(), 1)
	tween.tween_callback( func():
		start_infin_tweening_rotation())
	

var _time = 0.
@onready var _radius = $MeshInstance3D.global_position.y
func _physics_process(delta: float) -> void:
	_time += delta
	$MeshInstance3D.global_position.y += 0.5 * _radius * sin(6. * _time)
#var rotation_speed = 12.0
#var threshold = 0.9 * PI
#var delta_offset = PI / 12.0
#func _physics_process(delta: float) -> void:
	#var noise_x = Utils.noise_sampler.get_noise_1d(_skin.global_rotation.x)
	#var noise_y = Utils.noise_sampler.get_noise_1d(_skin.global_rotation.y)
	#_skin.global_rotation.x = lerp_angle(_skin.global_rotation.x, 
										#_skin.global_rotation.x + delta_offset, rotation_speed * delta)
	#_skin.global_rotation.z = lerp_angle(_skin.global_rotation.z, 
										#_skin.global_rotation.z + 1 * delta_offset, rotation_speed * delta)
#@onready var rot_timer: Timer = $RotationTimer
#func _physics_process(delta: float) -> void:
	#if rot_timer.is_stopped():
		#rot_timer.start()
		#var tween = get_tree().create_tween()
		#tween.tween_property($Sprite, "modulate", Color.RED, 1)
		#tween.tween_property($Sprite, "scale", Vector2(), 1)
		#tween.tween_callback($Sprite.queue_free)
	 #randomly rotate in a pleasing way
	
