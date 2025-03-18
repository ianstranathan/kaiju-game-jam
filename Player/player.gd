extends CharacterBody3D

@export var DEBUG: bool = false


@export_group("Movement")
@export var _camera: Camera3D
@export var rotation_speed := 12.0
var _last_movement_direction := Vector3.BACK
@export var v_x := 8.0
@export var x_h := 3.0
@export var acceleration := 20.0
@export var jump_height_units := 1.2
@onready var _h = jump_height_units + 0.2 * $CollisionShape3D.shape.height
@onready var v_0 :float = 2. * _h * v_x / x_h
@onready var _gravity :float = -2. * _h * (v_x * v_x) / (x_h * x_h)

# --------------------------------------------------
@export_group("Skin")
@export var _skin :Node3D
# --------------------------------------------------
@onready var initial_position:= global_position

@onready var skin_animation_player: AnimationPlayer = $"player animations/AnimationPlayer"
# --------------------------------------------------

enum States{
	IDLE,
	RUNNING,
	JUMPING
}
@onready var state = States.IDLE

func state_transtion(_state):
	state_entered( _state)
	state_exited( state )
	state = _state

func state_entered(_state: States):
	match _state:
		States.IDLE:
			skin_animation_player.play("Idle")
		States.RUNNING:
			skin_animation_player.play("running")
		States.JUMPING:
			skin_animation_player.play("jump")


func state_exited(_state: States):
	match _state:
		States.IDLE:
			pass
		States.RUNNING:
			pass
		States.JUMPING:
			pass


func start_game():
	state_transtion(state)


func _ready() -> void:	
	# -- TODO: I'm keeping this here for the splash screen
	skin_animation_player.play("running")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		global_position = initial_position
	elif event.is_action_pressed("turn_around"):
		turn_around()

# -- mutates velocity
func movement(dir: Vector3, delta: float) -> void:
	# -- separate components of velocity
	var y_velocity := velocity.y # -- save for gravity addition
	velocity.y = 0.0
	velocity = velocity.move_toward(dir * v_x, acceleration * delta)
	velocity.y = y_velocity + _gravity * delta
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		state_transtion(States.JUMPING)
		velocity.y += v_0
	move_and_slide()

func move_dir_from_input() -> Vector3:
	var raw_input := Input.get_vector("left", "right", "up", "down")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	return move_direction.normalized()


var _turned_around : bool = false
func turn_around():
	_turned_around = !_turned_around
	if _turned_around:
		var tween = create_tween()
		tween.tween_property(_skin, "global_rotation", Vector3(0., 3.0 * PI / 2.0, 0.), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	#_skin.global_rotation.y = lerp_angle(_skin.global_rotation.y, 270, rotation_speed * delta)

func _physics_process(delta: float) -> void:
	if _camera:
		var input_dir := Input.get_vector("left", "right", "up", "down")
		#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		var direction := move_dir_from_input()
		movement(direction, delta)

		if direction.length_squared() > 0.04:
			if is_on_floor():
				state_transtion(States.RUNNING)
			_last_movement_direction = direction
		else:
			if is_on_floor():
				state_transtion(States.IDLE)

		if !_turned_around:
			var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
			_skin.global_rotation.y = lerp_angle(_skin.global_rotation.y, target_angle, rotation_speed * delta)
