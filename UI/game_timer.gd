extends Label

var game_timer: Timer

signal game_timer_requested( fn: Callable)

func time_string()-> String:
	var t_msecs = game_timer.time_left * 1000.0
	var msecs = fmod(t_msecs, 1000.0)
	var seconds = fmod( floor(t_msecs / 1000.0), 60.0)
	var minutes = fmod( floor(t_msecs / 60000.0), 60.0)
	
	# leading number coeff in string interpolation is the padding
	# 3 -> minimum of 3 chars long
	return "%02d:%02d:%03d" % [minutes, seconds, msecs] 

func _physics_process(_delta):
	if game_timer:
		text = time_string()
	else:
		emit_signal("game_timer_requested", func(the_stage_game_timer: Timer): game_timer = the_stage_game_timer)
