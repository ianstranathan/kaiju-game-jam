extends Node

@export var game_scene: PackedScene = preload("res://game.tscn")
#@export var splash_screen_background_scene: PackedScene = preload("res://UI/splash_background.tscn")
#var game_instance: Node3D
@onready var game_instance_container: Node = $GameContainer# -- I am having a input / rendering priority issue
# -- I'm going to try and have a dedicated object that is def. lower than canvas layer
var splash_bg: Node3D
var is_paused: bool = false

func _ready() -> void:
	splash_screen()
	$CanvasLayer/StartMenu.started.connect( func():
		$CanvasLayer/StartMenu.visible = false
		#splash_bg.queue_free()
		game_instance_container.add_child(game_scene.instantiate()))
		#game_instance = game_scene.instantiate()
		#add_child(game_instance))
	
	$CanvasLayer/PauseMenu.resume.connect( func():
		var game_instance = game_instance_container.get_child(0)
		assert(game_instance)
		$CanvasLayer/PauseMenu.visible =  false
		pause(false))

	$CanvasLayer/PauseMenu.quit_to_main.connect( func():
		var game_instance = game_instance_container.get_child(0)
		assert(game_instance and  game_instance_container.get_children().size() == 1)
		game_instance.queue_free()
		splash_screen())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and game_instance_container.get_child(0):
		pause(!$CanvasLayer/PauseMenu.visible)


func splash_screen():
	$CanvasLayer/StartMenu.visible = true
	$CanvasLayer/PauseMenu.visible =  false
	#splash_bg = splash_screen_background_scene.instantiate()
	#add_child(splash_bg)


func pause(b: bool):
	# -- change visibility on canvas node
	$CanvasLayer/PauseMenu.visible = b
	# -- darken post processing quad
	$PostProcessingQuad.material_override.set_shader_parameter("darken", 1.0 if b else 0.0)
	var game_instance = game_instance_container.get_child(0)
	assert( game_instance )
	pause_node(game_instance, b)


func pause_node(a_node:Node, b: bool):
	if b:
		a_node.set_deferred("process_mode", PROCESS_MODE_DISABLED)
	else:
		a_node.set_deferred("process_mode", PROCESS_MODE_INHERIT)
