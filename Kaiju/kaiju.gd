extends CharacterBody3D

class_name Kaiju

signal fireball_shot( _fireball_instance, callback_fn: Callable)

@export var _skin: Node3D
@onready var skin_animation_player = _skin.get_node("AnimationPlayer")
@export var fireball_scene: PackedScene = preload("res://Kaiju/Fireball/fireball.tscn")
@export var player_ref: CharacterBody3D

@export_group("Movement")
@export var base_speed: float = 6.0
@onready var speed = base_speed
@onready var seeking_speed: float = 2. * speed
@export var base_acceleration: float = 40.0
@export var seeking_acceleration_mult: float = 2.0
@onready var seeking_acceleration: float = base_acceleration * seeking_acceleration_mult
@onready var acceleration : float = base_acceleration

@export_group("Awareness")
@export var swipe_radius: float    = 5.0
@export var closing_radius: float  = 10.0
@export var shooting_radius: float = 50.0

@export_group("Kinematics")
var _gravity = -30.0 # -- good enough

enum States{
	IDLE,
	CLOSING_IN,
	SEEKING,
	SWIPING,
	DYING,
	SHOOTING_FIREBALL
}
var state: States

# ------------------------------------------------------------------------------

func _ready() -> void:
	state = States.IDLE
	$FireballPauseTimer.timeout.connect( func(): shoot_fireball())
	$FireballEmitter.global_position = $ShootingCueSprite.global_position
	assert(player_ref)
	
	#skin_animation_player.animation_finished( func( anim_name: StringName):
		#if anim_name == "kaiju die":
			#Events.emit_signal("game_over", true))
	state_transtion(States.SEEKING )

func _physics_process(delta: float) -> void:
	var rel_pos = player_ref.global_position - global_position
	var dist = rel_pos.length()
	var dir  = rel_pos.normalized()
	state_from_dist(dist)
	if state != States.SWIPING:
		# -- don't want to get a degenerate lookat matrix from being too close
		look_at(-player_ref.global_position) # TODO
	
	if state == States.CLOSING_IN or state == States.SEEKING:
		velocity = velocity.move_toward(dir * speed, acceleration * delta)
		velocity.y += _gravity * delta
			# -- maybe do something if the collider is in group building?
		var coll = move_and_slide()


# ------------------------------------------------------------------------------
func state_transtion(_state):
	if state != _state:
		state_entered( _state)
		state_exited( state )
		state = _state


func state_entered(_state: States):
	match _state:
		States.IDLE:
			pass
		States.CLOSING_IN:
			skin_animation_player.speed_scale = 0.7
		States.SEEKING:
			skin_animation_player.play("kaiju run")
			skin_animation_player.speed_scale = 1.6
			acceleration = seeking_acceleration
			speed        = seeking_speed
		States.SWIPING:
			skin_animation_player.play("kaiju close attack")
			skin_animation_player.speed_scale = 1.3
		States.DYING:
			skin_animation_player.play("kaiju die")
		States.SHOOTING_FIREBALL:
			$FireballPauseTimer.start()
			skin_animation_player.pause()


func state_exited(_state: States):
	match _state:
		States.IDLE:
			pass
		States.CLOSING_IN:
			pass
		States.SEEKING:
			acceleration = base_acceleration
			speed        = base_speed
			skin_animation_player.speed_scale = 0.5
		States.SWIPING:
			pass
		States.DYING:
			pass
		States.SHOOTING_FIREBALL:
			$FireballPauseTimer.stop()
			skin_animation_player.play()


func state_from_dist(dist: float):
	#print( dist, ":: ", shooting_radius, ":: ", closing_radius, ":: ", swipe_radius )
	if dist > shooting_radius:
		state_transtion(States.SEEKING)
	elif dist > closing_radius and dist <=shooting_radius:
		if state != States.SEEKING:
			state_transtion(States.SHOOTING_FIREBALL)
	elif dist > swipe_radius and dist <=closing_radius:
		state_transtion(States.CLOSING_IN)
	else:
		state_transtion(States.SWIPING)


func shoot_fireball():
	if player_ref:
		var fireball_instance = fireball_scene.instantiate()
		var fire_ball_pos = $FireballEmitter.global_position
		# -- allow parent object to add it to a dedicated spot for clean up later
		emit_signal("fireball_shot", fireball_instance, func(): 
			fireball_instance.target_pos = player_ref.global_position
			fireball_instance.global_position = fire_ball_pos)
