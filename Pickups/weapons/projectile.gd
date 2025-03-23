extends Node3D

class_name Projectile

var dir: Vector3
var distance_travelled: float = 0.0
@export var speed: float = 45.0
@export var damage: float
@export var distance_threshold: float = 400

# -- TODO: has an attack :: damage and effects

func _ready() -> void:
	assert(dir)
	look_at(dir * 1000.) # -- orient z axis to target
	distance_travelled = 0.0


func _physics_process(delta: float) -> void:
	global_position += dir * speed * delta
	distance_travelled += 1
	if distance_travelled >= distance_threshold:
		queue_free()
