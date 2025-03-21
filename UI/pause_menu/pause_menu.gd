extends Control

signal resume
signal quit_to_main

@onready var resume_btn = $VBoxContainer/resume
@onready var quit_btn   = $VBoxContainer/quit


func _ready() -> void:
	visible = false
	resume_btn.button_down.connect( func():
		emit_signal("resume"))
	quit_btn.button_down.connect( func():
		emit_signal("quit_to_main"))
