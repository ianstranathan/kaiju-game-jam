extends Node

#@onready var noise_sampler: FastNoiseLite = FastNoiseLite.new()

@onready var rand_gen = RandomNumberGenerator.new()

func _ready() -> void:
	rand_gen.randomize()

func material_uniform_float_fn(v: float, mat: Material, p: String):
	mat.set_shader_parameter(p, v);
	
func material_shader_float_tween(tween: Tween, 
								 mat: Material, 
								 uniform_str: String, 
								 duration: float, 
								 starting_value=0.0, 
								 ending_value=1.0):
	tween.tween_method( material_uniform_float_fn.bind(mat, uniform_str), 
						starting_value, ending_value, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
