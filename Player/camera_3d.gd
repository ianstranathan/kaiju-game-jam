extends Camera3D

@onready var shake_timer = $Timer
func _ready() -> void:
	shake_timer.timeout.connect( func():
		reset_offset())
	Events.shake_camera.connect( func(shake_enum_amount: Events.ShakeType):
		shake_amt = shake_enum_amount
		shake_timer.start() )


@export var max_shake = 3.0
var shake_amt: Events.ShakeType
func rnd_shake( decay ):
	randomize()
	var shake_ratio = float(shake_amt) / 3.0
	h_offset = shake_ratio * (1. + randf()) * max_shake * decay
	randomize()
	v_offset = shake_ratio * (1. + randf()) * max_shake * decay


func _physics_process(delta: float) -> void:
	if !shake_timer.is_stopped():
		rnd_shake( exp(- (shake_timer.wait_time - shake_timer.time_left)))


func reset_offset():
	h_offset = 0
	v_offset = 0
