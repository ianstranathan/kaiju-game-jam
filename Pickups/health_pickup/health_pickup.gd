extends Pickup

@export var healing_amount: float = 25.0
func pickup_fn(body: Player) -> void:
	body.pickup_health(healing_amount)
	queue_free()
