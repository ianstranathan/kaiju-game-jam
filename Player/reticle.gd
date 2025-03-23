extends Sprite3D

@export var screen_dims := Vector2(16, 16)
@export var player_ref: Player
@export var _camera: Camera3D
@onready var _offset_len: float = (player_ref.global_position - global_position).length()

@onready var _plane  = Plane(Vector3(0, 0, 1), global_position.z)

func mouse_pos_3d():
	var mouse_pos = get_viewport().get_mouse_position()
	return mouse_pos
	#return _plane.intersects_ray(_camera.global_position, );
								
func _ready() -> void:
	visible = false
	assert(_camera)
	assert(player_ref)


func _physics_process(delta: float) -> void:
	if visible:
		var a_little_bit_towards_player = -0.1 * (player_ref.global_position.z - _camera.global_position.z)
		var z = _camera.global_position.z + a_little_bit_towards_player
		var dropPlane  = Plane(Vector3(0, 0, 1), z)
		var mouse_pos = get_viewport().get_mouse_position()
		var position3D = dropPlane.intersects_ray(
									 _camera.project_ray_origin(mouse_pos),
									 _camera.project_ray_normal(mouse_pos))
		
		global_position = Vector3(position3D.x, position3D.y, z)
