extends Area3D


@onready var explosion_scene: PackedScene = preload("res://VFX/explosion.tscn")
@onready var explosion_decal: PackedScene = preload("res://Kaiju/Fireball/scorch_decal.tscn")

signal exploded

var _can_explode: bool = true
func _ready() -> void:
	body_entered.connect( func(body):
		emit_signal("exploded")
		explode())
	#body_shape_entered.connect( func(body):
		#explode())
	#area_entered.connect( func(body):
		#explode())
	#area_shape_entered.connect( func(body):
		#explode())

# DEBUG
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("jump"):
		#explode()


func explode():
	if _can_explode:
		_can_explode = false
		get_children().map( func(child): child.visible = false)
		var explosion = explosion_scene.instantiate()
		add_child(explosion)
		explosion.global_rotation = Vector3(0., 0., 0.)
		explosion.global_position = global_position
		explosion.last_particle_done.connect( func(): queue_free())
		var anim_player = explosion.get_node("AnimationPlayer")
		anim_player.play("explode")
		anim_player.animation_finished.connect(func(anim_nam: String):
			var _decal: Decal = explosion_decal.instantiate()
			get_tree().get_root().add_child(_decal)
			_decal.global_position = global_position)
