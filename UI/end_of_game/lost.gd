extends Label
func show_result(won: bool) -> void:
	var label = $lost
	
	if won:
		label.text = "You Won!"
	else:
		label.text = "You Lost!"
	
	label.visible = true
