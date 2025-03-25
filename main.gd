extends Node

#@export var splash_screen_background_scene: PackedScene = preload("res://UI/splash_background.tscn")
#var game_instance: Node3D
@onready var game_instance_container: Node = $GameContainer# -- I am having a input / rendering priority issue
# -- I'm going to try and have a dedicated object that is def. lower than canvas layer
var splash_bg: Node3D
var is_paused: bool = false

func _ready() -> void:
	# -- Connect signals for UI and Game setup
	# -- for completed menu
	$CanvasLayer/StartMenu.started.connect( func():
		start_game())
	# -- for pause menu
	$CanvasLayer/PauseMenu.resume.connect( func():
		var game_instance = game_instance_container.get_child(0)
		assert(game_instance)
		$CanvasLayer/PauseMenu.visible =  false
		pause(false))
	$CanvasLayer/PauseMenu.restarted.connect( func():
		restart_game())
	$CanvasLayer/PauseMenu.quit_to_main.connect( func():
		back_to_main_fn())
	# -- for completed menu
	$CanvasLayer/CompletedMenu.restarted.connect( func(): 
		restart_game())
	$CanvasLayer/CompletedMenu.quit_to_main.connect( func():
		back_to_main_fn())
	# -- for game container
	$GameContainer.round_completed.connect(func(b: bool):
		$CanvasLayer/CompletedMenu.display_end_condition_text(b)
		pause(true, true))
	
	Events.round_completed.connect(func(won: bool):
		$CanvasLayer/CompletedMenu.display_end_condition_text(won)
		pause(true, true))


func start_game():
	$PostProcessingQuad.material_override.set_shader_parameter("darken", 0.0)
	#assert(game_instance_container.get_children().size() == 0)
	$CanvasLayer/StartMenu.visible = false
	game_instance_container.start_game()
	#game_instance_container.add_child(game_scene.instantiate())



func restart_game():
	#assert(game_instance_container.get_children().size() == 1)
	game_instance_container.remove_game_and_free()
	start_game()
	
	

func back_to_main_fn():
	#var game_instance = game_instance_container.get_child(0)
	#assert(game_instance and  game_instance_container.get_children().size() == 1)
	#game_instance.queue_free()
	game_instance_container.remove_game_and_free()
	$CanvasLayer/StartMenu.visible=true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and game_instance_container.get_child(0):
		pause(!$CanvasLayer/PauseMenu.visible)


func pause(b: bool, _end_of_round=false):
	if _end_of_round:
		$CanvasLayer/CompletedMenu.visible=true
	else:
		# -- change visibility on canvas node
		$CanvasLayer/PauseMenu.visible = b
	# -- darken post processing quad
	$PostProcessingQuad.material_override.set_shader_parameter("darken", 1.0 if b else 0.0)
	assert( game_instance_container.get_children().size() == 1)
	var game_instance = game_instance_container.get_child(0)
	assert( game_instance )
	pause_node(game_instance, b)


func pause_node(a_node:Node, b: bool):
	if b:
		a_node.set_deferred("process_mode", PROCESS_MODE_DISABLED)
	else:
		a_node.set_deferred("process_mode", PROCESS_MODE_INHERIT)


#func splash_screen():
	#$CanvasLayer/StartMenu.visible = true
	#$CanvasLayer/PauseMenu.visible =  false
	#splash_bg = splash_screen_background_scene.instantiate()
	#add_child(splash_bg)
