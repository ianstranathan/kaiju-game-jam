extends TextureButton

func _ready() -> void:
	mouse_entered.connect(func(): material.set_shader_parameter("is_hovering", 1.0))
	mouse_exited.connect(func(): material.set_shader_parameter("is_hovering", 0.0))
