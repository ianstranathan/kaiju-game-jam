extends Pickup

@export var damage_amount: float = 25.0

func _ready() -> void:
	super()
	# -- add to Kaiju health
	#$Area3D.body_entered

func pickup_fn(body: Player):
	body.take_damage(damage_amount)
	Events.emit_signal("shake_camera", 1)
	queue_free()
