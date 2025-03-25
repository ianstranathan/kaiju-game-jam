extends CharacterBody3D

class_name Player

@export var DEBUG: bool = false

signal health_changed( ratio: float)
signal projectile_shot( _projectile_instance, fn )
signal energy_used( ratio)
signal energy_refilled(ratio)
signal died

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export var rho_upper_limit := PI / 3.0
@export var rho_lower_limit := -PI / 3.0
@export var phi_upper_limit := PI / 3.0
@export var phi_lower_limit := -PI / 6.0
@onready var _camera_pivot: Node3D = $CameraPivotPoint
@onready var _camera: Camera3D = $CameraPivotPoint/SpringArm3D/Camera3D
@onready var cam_offset_len: float = (_camera.global_position - global_position).length()

var _camera_input_direction := Vector2.ZERO

@export_group("Movement")
@export var rotation_speed := 12.0
var _last_movement_direction := Vector3.BACK
@export var base_v_x := 8.0
@onready var v_x := base_v_x
@onready var speedy_v_x = v_x * 10.0
@export var x_h := 3.0
@export var base_acceleration := 20.0
@onready var acceleration := base_acceleration
@export var jump_height_units := 2.0
@onready var _h = jump_height_units + 0.2 * $CollisionShape3D.shape.height
@onready var v_0 :float = 2. * _h * v_x / x_h
@onready var _gravity :float = -2. * _h * (v_x * v_x) / (x_h * x_h)

@export_group("Accelerations")
@export var oil_acceleration_factor: float = 80.0
@onready var oil_acceleration = base_acceleration / oil_acceleration_factor

# --------------------------------------------------
@export_group("Skin")
@export var _skin :Node3D

@export_group("energy")
@export var num_energy_shots = 10.0
@export var energy = 1.0
# --------------------------------------------------
@onready var initial_position:= global_position

@onready var skin_animation_player: AnimationPlayer = $"player animations/AnimationPlayer"
# --------------------------------------------------

@export var basic_projectile: PackedScene = preload("res://Pickups/weapons/basic/basic.tscn")

func _ready() -> void:
	assert(_camera)
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	_camera.current = true
	$OilTimer.timeout.connect(func():
		environemtnal_state_transition( EnvironmentalStates.NORMAL ))
	$SpeedBoostTimer.timeout.connect( func():
		environemtnal_state_transition( EnvironmentalStates.NORMAL ))
	# --------
	$Health.health_depleted.connect(func():
		emit_signal("died")
	)
	$Health.health_changed.connect( func(ratio: float): 
		emit_signal("health_changed", ratio))
	# -- TODO: I'm keeping this here for the splash screen
	skin_animation_player.play("running")


@export var static_cam: bool = true

func cam_fn(delta: float):
	#if !static_cam:
		#_camera_pivot.rotation.x += _camera_input_direction.y * delta
		#_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, phi_lower_limit, phi_upper_limit)
		#_camera_pivot.rotation.y += _camera_input_direction.x * delta
		#_camera_pivot.rotation.y = clamp(_camera_pivot.rotation.y, rho_lower_limit, rho_upper_limit)
		#_camera_input_direction = Vector2.ZERO
	
	# -- Camera pitch to shoot slightly easier
	_camera_pivot.rotation.x -= _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, phi_lower_limit, phi_upper_limit)
	_camera.look_at(global_position)


func _physics_process(delta: float) -> void:
	cam_fn(delta)
	var direction := move_dir_from_input() if $SpeedBoostTimer.is_stopped() else _camera.global_basis.z
	movement(direction, delta)

	if direction.length_squared() > 0.04:
		if is_on_floor():
			state_transtion(States.RUNNING)
		_last_movement_direction = direction
	else:
		if is_on_floor():
			state_transtion(States.IDLE)

	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.global_rotation.y, target_angle, rotation_speed * delta)


func move_dir_from_input() -> Vector3:
	var raw_input := Input.get_vector("left", "right", "up", "down")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	return move_direction.normalized()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		shoot_projectile()
	if DEBUG and event.is_action_pressed("reset"):
		global_position = initial_position
	
	if event is InputEventMouseMotion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity
	#if event.is_action_pressed("pause"):
		#if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		#elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#elif event.is_action_pressed("left_click"):
		#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	#  -- DEBUG util
	

	#if event is InputEventMouseMotion and Input.MOUSE_MODE_CAPTURED:
		#_camera_input_direction = event.screen_relative * mouse_sensitivity
#func _unhandled_input(event: InputEvent) -> void:
	#var is_camera_motion := (
		#event is InputEventMouseMotion and
		#Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	#)
	#if is_camera_motion:
		#_camera_input_direction = event.screen_relative * mouse_sensitivity


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


func progressive_accl_increase(delta: float):
	# -- there's an edge case where you get "stuck" on static geometry
	# -- if your accl is too low
	if acceleration < base_acceleration:
		acceleration += delta


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
		
	# -- Check for edge case with getting stuck in geometry because
	# -- you can't overcome the collision resolution
	var tmp_vel_check_from_input = velocity
	var coll = move_and_slide()
	if coll:
		var _collision = get_last_slide_collision()
		if _collision.get_collider().is_in_group("Obstacles") and tmp_vel_check_from_input.length_squared() > 1.0:
			acceleration = base_acceleration


# -- TODO: can't make up my mind how I want this done
func take_hit( attack: Attack):
	damage_visual_cue()
	if !DEBUG:
		$Hitbox.take_hit( attack )

func take_damage(damage: float):
	damage_visual_cue()
	if !DEBUG:
		$Hitbox.take_damage( damage )


@onready var anim_material: Material = $"player animations/Armature/Skeleton3D/player_Cube".material_override
func damage_visual_cue() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	Utils.material_shader_float_tween(tween, anim_material, "hit_interpolant", 0.5, 0., 0.6)
	tween.tween_callback( func():
		anim_material.set_shader_parameter("hit_interpolant", 0.))
	
enum EnvironmentalStates{
	NORMAL,
	OILY,
	SPEEDY,
}
@onready var environmental_state = EnvironmentalStates.NORMAL
func environemtnal_state_transition( new_environmental_state: EnvironmentalStates):
	enter_env_state( new_environmental_state)
	exit_env_state( environmental_state) 
	environmental_state = environmental_state


func enter_env_state( new_environmental_state: EnvironmentalStates):
	match new_environmental_state:
		EnvironmentalStates.NORMAL:
			acceleration = base_acceleration
			skin_animation_player.speed_scale = 1.0
			v_x = base_v_x
		EnvironmentalStates.OILY:
			acceleration = oil_acceleration
		EnvironmentalStates.SPEEDY:
			v_x = speedy_v_x
			skin_animation_player.speed_scale = 3.0
			$SpeedBoostTimer.start()
			#acceleration = oil_acceleration

func exit_env_state( last_environmental_state: EnvironmentalStates):
	match last_environmental_state:
		EnvironmentalStates.NORMAL:
			pass
		EnvironmentalStates.OILY:
			pass
		EnvironmentalStates.SPEEDY:
			pass


func acceleration_curve( _name: String, b: bool=false):
	# -- type, is entering or leaving
	match _name:
		"Oil":
			if b:
				environemtnal_state_transition( EnvironmentalStates.OILY)
			else:
				$OilTimer.start()
		"Speed Boost":
			environemtnal_state_transition( EnvironmentalStates.SPEEDY)


func mouse_pos_3d() -> Vector3:
	var a_little_bit_towards_player = 0.2 * (global_position.x - _camera.global_position.x)
	var x = _camera.global_position.x + a_little_bit_towards_player
	var dropPlane  = Plane(Vector3(1, 0, 0), x)
	var mouse_pos = get_viewport().get_mouse_position()
	var intersection_point = dropPlane.intersects_ray( _camera.project_ray_origin(mouse_pos),
									 _camera.project_ray_normal(mouse_pos))
	return intersection_point


# -- TODO: remove position and replace with gun model position
func shoot_projectile():
	# TODO: hardcoding one weapon:
	if $ShootingCooldownTimer.is_stopped() and energy > 0.:
		use_energy()
		$ShootingCooldownTimer.start()
		var basic_projectile_instance = basic_projectile.instantiate()
		# -- allow parent object to add it to a dedicated spot for clean up later
		#if !DEBUG:
			#emit_signal("projectile_shot", basic_projectile_instance, func(): 
					#basic_projectile_instance.dir = ($Sprite3D.global_position - global_position).normalized
					#basic_projectile_instance.global_position = $Sprite3D.global_position + 2. * basic_projectile_instance.dir)
		var _mouse_point_3d = mouse_pos_3d()
		var cam_pos = _camera.global_position
		var dir = _mouse_point_3d - cam_pos
		var pos = $CollisionShape3D.global_position + 2. * dir
		
		basic_projectile_instance.dir = dir
		basic_projectile_instance.visible = false

		# -- we want the muzzle flash to agree with the motion
		$MuzzleFlash.global_position = pos
		$MuzzleFlash/AnimationPlayer.play("flash")
		$MuzzleFlash/AnimationPlayer.animation_finished.connect( func(_anim_name):
			emit_signal("projectile_shot", basic_projectile_instance, func():
				if basic_projectile_instance: # -- it hit wall too fast?
					basic_projectile_instance.visible = true
					basic_projectile_instance.global_position = pos
			)
		)
	
	else:
		# -- red flashing polish
		emit_signal("energy_used", 0.)


func pickup_health(amount: float):
	$Health.heal(amount)


@onready var ammo
func get_ammo(amount: float) -> void:
	ammo += amount


func use_energy():
	energy -= 1.0 / num_energy_shots
	energy = clamp(energy, 0., 1.)
	emit_signal("energy_used", energy)


func refill_energy():
	# -- TODO: hardcoding just to refill
	energy = 1.0
	emit_signal("energy_refilled", 1.0)
