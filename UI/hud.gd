extends Control

@onready var heart_tex_rect: PackedScene = preload("res://UI/heart_texture_rect.tscn")
@export var num_hearts: int = 3

signal game_timer_requested( fn: Callable )

func _ready() -> void:
	$MarginContainer4/PanelContainer.game_timer_requested.connect( func(fn: Callable):
		emit_signal("game_timer_requested", fn))
	out_of_energy_timer.timeout.connect( func():
		$MarginContainer3/PanelContainer/TextureRect.material.set_shader_parameter("_out_of", 0.0))
	make_hearts( num_hearts)


func update_health( ratio: float):
	var how_many_hearts_to_have = floor(num_hearts * ratio)
	var how_many_hearts_to_change = how_many_hearts_to_have - $MarginContainer/HBoxContainer.get_children().size()
	if how_many_hearts_to_change > 0:
		make_hearts( how_many_hearts_to_change)
	else:
		remove_hearts( -1 * how_many_hearts_to_change)

func make_hearts( n: int):
	for i in range(n):
		var heart = heart_tex_rect.instantiate()
		$MarginContainer/HBoxContainer.add_child(heart)
		if i == n - 1: # -- is the last heart / leading heart
			$MarginContainer/HBoxContainer.get_children()[-1].material.set_shader_parameter("is_leading_heart", 1.0)


func remove_hearts(n: int):
	var heart_tex_rects = $MarginContainer/HBoxContainer.get_children()
	for i in range(n):
		heart_tex_rects.pop_back().queue_free()
	if heart_tex_rects.size() > 0:
		heart_tex_rects[-1].material.set_shader_parameter("is_leading_heart", 1.0)


@onready var out_of_energy_timer = $MarginContainer3/PanelContainer/TextureRect/OutOfTimer
func update_energy( ratio: float):
	if ratio <= 0.:
		out_of_energy_timer.start()
		$MarginContainer3/PanelContainer/TextureRect.material.set_shader_parameter("_out_of", 1.0)
	$MarginContainer3/PanelContainer/TextureRect.material.set_shader_parameter("amount", ratio)

func update_kaiju_health( ratio: float):
	$MarginContainer2/PanelContainer/TextureRect.material.set_shader_parameter("amount", ratio)


func _process(delta: float) -> void:
	$Reticle.position = get_viewport().get_mouse_position()
