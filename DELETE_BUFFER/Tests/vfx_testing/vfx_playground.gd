extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Fireball.exploded.connect( func():
		$Camera3D.shake())
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		$AnimationPlayer.play("test")
#create_shake_tween(_t_delta)

#func create_shake_tween(_t: float):
	#var tween = create_tween()
	#var rnd =  randf()
	#tween.tween_property($Camera3D, "global_position", $Camera3D.global_position + Vector3(rnd, rnd, rnd), _t)
	#tween.tween_callback( func():
		#shake_duration -= _t
		#if shake_duration > 0:
			#create_shake_tween( _t ))
