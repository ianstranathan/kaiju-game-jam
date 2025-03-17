extends Node3D

@onready var _imported_mesh := $building_A_withoutBase/building_A_withoutBase
func _ready() -> void:
	static_body_from_mesh_aabb(_imported_mesh)

func mesh_aabb_dims(_mesh: MeshInstance3D) -> AABB:
	return _mesh.global_transform * _mesh.get_aabb()

func static_body_from_mesh_aabb(_mesh: MeshInstance3D):
	var sb = StaticBody3D.new();
	var cs = CollisionShape3D.new()
	var bs = BoxShape3D.new()
	var aabb = mesh_aabb_dims(_mesh)
	var _size = aabb.size
	bs.size = _size
	cs.shape = bs
	sb.add_child(cs)
	add_child(sb)
	sb.global_position = _imported_mesh.global_position + Vector3(0., _size.y / 2.0, 0.)


var _t: float = 0.0
@onready var _radius = 4.0
@onready var initial_height = global_position.y
@onready var _cam = $Camera3D

func _physics_process(delta: float) -> void:
	# -- move in a circle relative to origin
	var target = _imported_mesh.global_position
	_t += delta
	var pos =  target + Vector3(_radius * cos(_t), initial_height, _radius * sin(_t))
	_cam.global_position = Vector3(pos.x, _cam.global_position.y, pos.z)
	_cam.look_at(target)
