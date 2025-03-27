extends Node

enum ShakeType {
	SMALL,
	MEDIUM,
	BIG
}
signal round_completed( won: bool )
signal shake_camera(shake_amount: ShakeType)
