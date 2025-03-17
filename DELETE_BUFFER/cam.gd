extends Camera3D


@export var target: CharacterBody3D

func _ready() -> void:
	assert(target != null)

var _t: float = 0.0
@onready var _radius = global_position.x
@onready var initial_height = global_position.y
func _physics_process(delta: float) -> void:
	# -- move in a circle relative to origin
	_t += 0.5 * delta
	global_position =  Vector3( _radius * cos(_t), initial_height, _radius * sin(_t))
	# -- and look at target
	look_at(target.global_position)
