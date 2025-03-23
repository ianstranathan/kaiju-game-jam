extends Node3D


func _ready() -> void:
	visible = false
	$AnimationPlayer.animation_finished.connect( func(anim_name):
		visible = false)
