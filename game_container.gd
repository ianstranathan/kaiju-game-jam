extends Node

signal round_completed( b: bool )
#signal game_instance_cleaned_up()

@export var game_scene: PackedScene = preload("res://game.tscn")

# func _ready() -> void:
	#child_entered_tree.connect( func(child: Node3D):
		#child.round_completed.connect( func(win_or_lose: bool):
			#emit_signal("round_completed", win_or_lose)))
	#child_exiting_tree.connect( func(child: Node3D):
		#child.round_completed.connect( func(win_or_lose: bool):
			#emit_signal("game_instance_cleaned_up")))

func start_game():
	assert( get_children().size() == 0)
	var game_instance = game_scene.instantiate()
	add_child(game_instance)
	game_instance.round_completed.connect( func(won: bool):
		emit_signal("round_completed", won))


func remove_game_and_free():
	assert( get_children().size() == 1)
	var game_ref = get_child(0) 
	remove_child( game_ref)
	game_ref.queue_free()
	
