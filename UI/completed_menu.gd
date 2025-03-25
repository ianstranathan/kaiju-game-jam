extends Control

signal restarted
signal quit_to_main

@onready var restart_btn = $VBoxContainer/restart
@onready var quit_btn   = $VBoxContainer/quit


func _ready() -> void:
	visible = false
	restart_btn.button_down.connect( func():
		btn_callback("restarted"))
	quit_btn.button_down.connect( func():
		btn_callback("quit_to_main"))


func btn_callback(s: String):
	visible = false
	assert(s == "restarted" or s == "quit_to_main")
	emit_signal(s)


func display_end_condition_text(win_or_lose: bool):
	if win_or_lose:
		$VBoxContainer/PanelContainer/Label.text = "WIN!"
	else:
		$VBoxContainer/PanelContainer/Label.text = "FAILURE"
