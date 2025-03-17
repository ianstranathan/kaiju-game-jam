extends Node3D

@onready var main_cam: Camera3D = $Camera3D
@onready var kaiju_cam: Camera3D = $KaijuSubViewport/Camera3D

func _ready() -> void:
	# -- just hardcoding aspect ratio in shader -- CHANGE ME
	#print( get_viewport().size)
	#$TestSet/AnimationPlayer.play("spin_dummy")
	$AnimationPlayer.play("dummy_movement")
	
#func set_cam_arr_to_cam_pos_and_rot(cam_ref: Camera3D, arr_of_cams: Array[Camera3D]):
	#arr_of_cams.map(func(_cam: Camera3D):
		#_cam.global_rotation = cam_ref.global_rotation
		#_cam.global_position = cam_ref.global_position)


func rot_light_to_something(_something: Node3D):
	$DirectionalLight3D.global_rotation =  $DirectionalLight3D.global_position.angle_to(_something.global_position)


func _physics_process(delta: float) -> void:
	# -- kaiju cam is an alias of the main camera
	kaiju_cam.global_rotation = main_cam.global_rotation
	kaiju_cam.global_position = main_cam.global_position
