extends Control

signal resume
signal quit_to_main
signal restarted

@onready var resume_btn = $VBoxContainer/resume
@onready var restart_btn = $VBoxContainer/restart
@onready var quit_btn   = $VBoxContainer/quit

func _ready() -> void:
	visible = false
	resume_btn.button_down.connect( func():
		btn_callback("resume"))
	restart_btn.button_down.connect( func():
		btn_callback("restarted"))
	quit_btn.button_down.connect( func():
		btn_callback("quit_to_main"))

func btn_callback(s: String):
	visible = false
	emit_signal(s)
