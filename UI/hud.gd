extends Control

@onready var heart_tex_rect: PackedScene = preload("res://UI/heart_texture_rect.tscn")
@export var num_hearts: int = 3
func _ready() -> void:
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
	

func remove_hearts(n: int):
	var heart_tex_rects = $MarginContainer/HBoxContainer.get_children()
	for i in range(n):
		heart_tex_rects.pop_back().queue_free()
	if heart_tex_rects.size() > 0:
		heart_tex_rects[-1].material.set_shader_parameter("is_leading_heart", 1.0)

@onready var extraction_bar = $VBoxContainer/MarginContainer2/PanelContainer/TextureRect
func update_timer( ratio: float):
	extraction_bar.material.set_shader_parameter("amount", ratio)
