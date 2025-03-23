extends Node

class_name Health

signal health_depleted
signal health_changed

@export var starting_health: float
@onready var health = starting_health

func take_attack_damage( damage: float):
	health -= damage
	if health < 0.0:
		emit_signal("health_depleted")
	else:
		emit_signal("health_changed", health / starting_health)


func heal( _health):
	health += _health
	health = clamp(health, 0, 100)
	emit_signal("health_changed", health / starting_health)
