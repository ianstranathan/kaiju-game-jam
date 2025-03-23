extends Pickup

func pickup_fn( body: Player):
	body.refill_energy()
	queue_free()
