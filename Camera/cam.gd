extends Camera3D

@export var target: CharacterBody3D

@export  var camera_distance := 7.0
@onready var _offset:Vector3
@export var look_down_angle = PI / 6.0
# ------------------------------------------------------------------------------
# -- NOISE
@export_group("Shake Params")
# How quickly to move through the noise
@export var NOISE_SHAKE_SPEED: float = 30.0
@export var NOISE_SWAY_SPEED: float = 1.0
# Noise returns values in the range (-1, 1)
# So this is how much to multiply the returned value by
@export var NOISE_SHAKE_STRENGTH: float = 30.0
@export var NOISE_SWAY_STRENGTH: float = 10.0
# The starting range of possible offsets using random values
@export var RANDOM_SHAKE_STRENGTH: float = 15.0
# Multiplier for lerping the shake strength to zero
@export var SHAKE_DECAY_RATE: float = 3.0

@onready var noise: FastNoiseLite = FastNoiseLite.new()
var noise_i: float = 0.0
@onready var rand = RandomNumberGenerator.new()
var shake_type: int = ShakeType.Random
var shake_strength: float = 0.0

enum ShakeType {
	Random,
	NOISE,
	Sway
}

# ------------------------------------------------------------------------------

func _ready() -> void:
	Events.shake_camera.connect( func(shake_type_int: int):
		assert(shake_type_int in [1,2,3])
		is_shaking = true
		shake_type = shake_type_int
		match shake_type:
			ShakeType.Random:
				apply_random_shake()
			ShakeType.NOISE:
				apply_noise_shake()
			ShakeType.Sway:
				apply_noise_sway()
		)
	# -- Noise ready
	rand.randomize()
	# Randomize the generated noise
	noise.seed = rand.randi()
	# Period affects how quickly the noise changes values
	#noise.period = 2
	# --
	assert(target)
	global_position.y = camera_distance * sin(look_down_angle)
	_offset = (global_position - target.global_position).normalized() * camera_distance

var is_shaking = false
func _physics_process(delta: float) -> void:
	global_position = target.global_position + _offset
	look_at(target.global_position)
	
	if is_shaking:
		shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY_RATE * delta)
		
		if shake_strength < 0.01:
			is_shaking = false

		var shake_offset: Vector2
		
		match shake_type:
			ShakeType.Random:
				shake_offset = get_random_offset()
			ShakeType.NOISE:
				shake_offset = get_noise_offset(delta, NOISE_SHAKE_SPEED, shake_strength)
			ShakeType.Sway:
				shake_offset = get_noise_offset(delta, NOISE_SWAY_SPEED, NOISE_SWAY_STRENGTH)
		
		# Shake by adjusting camera.offset so we can move the camera around the level via it's position
		h_offset = shake_offset.x
		v_offset = clamp(shake_offset.y, 0., global_position.y / 4.0)

func apply_random_shake() -> void:
	shake_strength = RANDOM_SHAKE_STRENGTH
	shake_type = ShakeType.Random
	
func apply_noise_shake() -> void:
	shake_strength = NOISE_SHAKE_STRENGTH
	shake_type = ShakeType.NOISE
	
func apply_noise_sway() -> void:
	shake_type = ShakeType.Sway

func get_noise_offset(delta: float, speed: float, strength: float) -> Vector2:
	noise_i += delta * speed
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * strength,
		noise.get_noise_2d(100, noise_i) * strength
	)

func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strength, shake_strength),
		rand.randf_range(-shake_strength, shake_strength)
	)
