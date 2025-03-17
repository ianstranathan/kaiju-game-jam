extends Node3D

@export var game_scene: PackedScene = preload("res://game.tscn")
@export var splash_screen_background_scene: PackedScene = preload("res://UI/splash_background.tscn")
@onready var splash_bg: Node3D = splash_screen_background_scene.instantiate()

var game_instance: Node3D
func _ready() -> void:
	add_child(splash_bg)
	
	$CanvasLayer/StartMenu.started.connect( func():
		$CanvasLayer/StartMenu.visible = false
		splash_bg.queue_free()
		game_instance = game_scene.instantiate()
		add_child(game_instance))
	
