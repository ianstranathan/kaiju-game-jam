extends Node3D


@onready var explosion_scene: PackedScene = preload("res://VFX/explosion.tscn")
@onready var explosion_decal: PackedScene = preload("res://Kaiju/Fireball/scorch_decal.tscn")

@export var speed: float = 40.0

signal exploded( _a_decal_instance: Decal, callback_fn: Callable)

var _can_explode: bool = true
var target_pos: Vector3
var dir: Vector3
func _ready() -> void:
	# -- if fireball never hits
	$Timer.timeout.connect( func(): queue_free())
	$Timer.start()

	$Area3D.body_entered.connect( func(_body):
		explode())

func explode():
	if _can_explode:
		_can_explode = false
		get_children().map( func(child): if child is not Timer: child.visible = false)
		var explosion = explosion_scene.instantiate()
		get_tree().get_root().add_child(explosion)
		explosion.look_at(target_pos)
		explosion.global_position = target_pos
		
		# ------------------
		
		var _decal: Decal = explosion_decal.instantiate()
		#get_tree().get_root().add_child(_decal)
		emit_signal("exploded", _decal, func(): _decal.global_position = target_pos)
		queue_free()
		
		# -------------- DELETE BUFFER
		# -- since the explosion was using parent (fireballs)
		# -- position data, it created a nice streak effect, but animation lost
		# -- power
		#explosion.last_particle_done.connect( func(): 
			#explosion.queue_free())
		#var anim_player = explosion.get_node("AnimationPlayer")
		#anim_player.play("explode")
		#anim_player.animation_finished.connect(func(anim_nam: String):
			#var _decal: Decal = explosion_decal.instantiate()
			#get_tree().get_root().add_child(_decal)
			#_decal.global_position = global_position)

func _physics_process(delta: float) -> void:
	if dir:
		global_position += dir * speed * delta
	else:
		look_at(target_pos) # -- orient z axis to target
		dir = (target_pos - global_position).normalized()
