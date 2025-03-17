extends Camera3D

@export var target: CharacterBody3D

@export var birds_eye_displacement := Vector3(30., 20., 0.)
@export  var camera_distance := 7.0
@onready var _offset:Vector3
var can_birds_eye: bool = true
@export var look_down_angle = PI / 6.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

func _ready() -> void:
	assert(target)
	global_position.y = camera_distance * sin(look_down_angle)
	_offset = (global_position - target.global_position).normalized() * camera_distance


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("birds_eye"):
		var tween = create_tween()
		var pos = global_position + (birds_eye_displacement if can_birds_eye else _offset)
		tween.tween_property(self, "global_position", pos, 0.8)
		tween.tween_callback( func(): can_birds_eye = !can_birds_eye)


func _physics_process(delta: float) -> void:
	if can_birds_eye:
		global_position = target.global_position + _offset
	look_at(target.global_position)
	
