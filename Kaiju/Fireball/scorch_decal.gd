extends Decal


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("scorch")
	$AnimationPlayer.animation_finished.connect( func(anim):
		queue_free())
