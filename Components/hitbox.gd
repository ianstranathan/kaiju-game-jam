extends Node

class_name Hitbox

signal hitbox_hit( _attack: Attack )
@export var health: Health

func _ready() -> void:
	assert(health)

func take_hit(attack: Attack):
	health.take_attack_damage( attack.damage )
	emit_signal("hitbox_hit", attack)
