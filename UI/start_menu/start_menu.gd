extends Control

signal started

@onready var start_btn = $VBoxContainer/start
@onready var quit_btn = $VBoxContainer/quit


func _ready() -> void:
	start_btn.button_down.connect( func():
		emit_signal("started"))
	quit_btn.button_down.connect( func():
		get_tree().quit())
