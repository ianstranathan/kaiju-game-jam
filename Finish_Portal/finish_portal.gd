extends Node3D

class_name FinishPortal

func _ready() -> void:
	$Area3D.body_entered.connect( func(body):
		if body is Player:
			Events.emit_signal("round_completed", true))
