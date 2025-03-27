extends Control

#@onready var heart_tex_rect: PackedScene = preload("res://UI/heart_texture_rect.tscn")
@onready var heart_tex_rect: PackedScene = preload("res://UI/hearts/jen_heart.tscn")
@export var num_hearts: int = 4

signal game_timer_requested( fn: Callable )

@onready var out_of_energy_timer = $JenBar/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/MarginContainer3/PanelContainer/TextureRect/OutOfTimer
@onready var energy_bar = $JenBar/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/MarginContainer3/PanelContainer/TextureRect

func _ready() -> void:
	$JenBar/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/Label.game_timer_requested.connect( func(fn: Callable):
		emit_signal("game_timer_requested", fn))
	out_of_energy_timer.timeout.connect( func():
		energy_bar.material.set_shader_parameter("_out_of", 0.0))
	make_hearts( num_hearts)


func update_health( ratio: float):
	var how_many_hearts_to_have = floor(num_hearts * ratio)
	var how_many_hearts_to_change = how_many_hearts_to_have - heart_container.get_children().size()
	if how_many_hearts_to_change > 0:
		make_hearts( how_many_hearts_to_change)
	else:
		remove_hearts( -1 * how_many_hearts_to_change)

@onready var heart_container = $JenBar/PanelContainer/MarginContainer/HBoxContainer/Hearts
func make_hearts( n: int):
	for i in range(n):
		var heart = heart_tex_rect.instantiate()
		heart_container.add_child(heart)
		if i == n - 1: # -- is the last heart / leading heart
			heart_container.get_children()[-1].material.set_shader_parameter("is_leading_heart", 1.0)


func remove_hearts(n: int):
	var heart_tex_rects = heart_container.get_children()
	for i in range(n):
		heart_tex_rects.pop_back().queue_free()
	if heart_tex_rects.size() > 0:
		heart_tex_rects[-1].material.set_shader_parameter("is_leading_heart", 1.0)


func update_energy( ratio: float):
	if ratio <= 0.:
		out_of_energy_timer.start()
		energy_bar.material.set_shader_parameter("_out_of", 1.0)
	energy_bar.material.set_shader_parameter("amount", ratio)

@onready var starting_num_eyeballs = $JenBar/PanelContainer/MarginContainer/HBoxContainer/Eyeballs.get_children().size()
func update_kaiju_health( ratio: float):
	var num_eyeballs = floor(starting_num_eyeballs * ratio)
	var num_eyeballs_in_hud_curr = $JenBar/PanelContainer/MarginContainer/HBoxContainer/Eyeballs.get_children().size()
	if num_eyeballs_in_hud_curr > num_eyeballs:
		var diff = num_eyeballs_in_hud_curr - num_eyeballs
		for i in range(diff):
			$JenBar/PanelContainer/MarginContainer/HBoxContainer/Eyeballs.get_children().pop_back().queue_free()
	#$MarginContainer2/PanelContainer/TextureRect.material.set_shader_parameter("amount", ratio)

func _process(delta: float) -> void:
	$Reticle.position = get_viewport().get_mouse_position()
