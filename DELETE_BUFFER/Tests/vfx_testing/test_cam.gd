extends Camera3D

@export var target: Node3D
# Called when the node enters the scene tree for the first time.
var offset: Vector3
@export var DEBUG: bool = false
func _ready() -> void:
	$Timer.timeout.connect( func(): 
		can_shake = false
		# -- probably tween this
		offset = pre_shake_offset)
	assert(target)
	offset = (target.global_position - global_position).normalized() * 7.0

func _physics_process(delta: float) -> void:
	if !DEBUG and is_instance_valid(target) and target:
		global_position = target.global_position + offset
		global_position.y = max(1, target.global_position.y)
		look_at(target.global_position)


@onready var noise: FastNoiseLite = FastNoiseLite.new();
var can_shake: bool = false
var time = 100.0
var time_offset_x = 67.4
var time_offset_y = 114.3

func shake():
	pre_shake_offset = global_position
	can_shake = true
	$Timer.start()

@onready var pre_shake_offset: Vector3 = global_position

func _process(delta: float) -> void:
	if can_shake:
		time += delta
		var x = randf_range(-1, 1) * 100
		var y = randf_range(-1, 1) * 100
		offset.x = x * noise.get_noise_2d(time, 1.3  * time)
		offset.y = y * noise.get_noise_2d(1.2 * time, 1.7  * time)
		#offset.x = noise.get_noise_2d(time, 1.3  * time) * 10
		#offset.y = noise.get_noise_2d(1.2 * time, 1.7 * time) * 10
		#rotation_degrees = noise.get_noise_3d(0, 0, time * time_scale) * max_r * shake
		
