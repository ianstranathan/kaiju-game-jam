extends Node3D


func _ready() -> void:
	Events.emit_signal("shake_camera",  3 )
	$AnimationPlayer.play("explode")
	$smoke.finished.connect( func(): queue_free() )

	$Area3D.body_entered.connect( func(body):
		if body is Player or body is Kaiju:
			body.take_hit($Attack))
