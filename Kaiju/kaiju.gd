extends CharacterBody3D

class_name Kaiju

signal fireball_shot( _fireball_instance, callback_fn: Callable)

@export var _skin: Node3D
@onready var skin_animation_player = _skin.get_node("AnimationPlayer")
@export var fireball_scene: PackedScene = preload("res://Kaiju/Fireball/fireball.tscn")
@export var player_ref: CharacterBody3D

@export var speed: float = 6.0
@export var acceleration : float = 40.0


enum States{
	SWIPING,
	RUNNING,
	DYING,
	SHOOTING_FIREBALL
}
var state: States
# ------------------------------------------------------------------------------
func _ready() -> void:
	$FireballEmitter.global_position = $ShootingCueSprite.global_position
	$StartTimer.start()
	$FireballTimer.start()
	assert(player_ref)
	$FireballTimer.timeout.connect( func(): 
		$ShootingCueSprite.visible = false
		shoot_fireball())
	state_transtion(States.RUNNING )
var _gravity = -30.0
func _physics_process(delta: float) -> void:
	if $StartTimer.is_stopped():
		#look_at(player_ref.global_position, Vector3.UP)
		if state  == States.RUNNING:
			var dir = (player_ref.global_position - global_position).normalized()
			velocity = velocity.move_toward(dir * speed, acceleration * delta)
			velocity.y += _gravity * delta
			
			# -- maybe do something if the collider is in group building?
			var coll = move_and_slide()
	
	if $FireballTimer.time_left < 0.4 * $FireballTimer.wait_time:
		$ShootingCueSprite.visible = true
# ------------------------------------------------------------------------------
# -- this thing just goes down a track
func state_transtion(_state):
	state_entered( _state)
	state_exited( state )
	state = _state


func state_entered(_state: States):
	match _state:
		States.SWIPING:
			skin_animation_player.play("kaiju close attack")
		States.RUNNING:
			skin_animation_player.play("kaiju run")
		States.SHOOTING_FIREBALL:
			pass #skin_animation_player.play("jump")


func state_exited(_state: States):
	match _state:
		States.RUNNING:
			pass
		States.RUNNING:
			pass
		States.SHOOTING_FIREBALL:
			pass


func shoot_fireball():
	if player_ref:
		var fireball_instance = fireball_scene.instantiate()
		var fire_ball_pos = $FireballEmitter.global_position
		# -- allow parent object to add it to a dedicated spot for clean up later
		emit_signal("fireball_shot", fireball_instance, func(): 
			fireball_instance.target_pos = player_ref.global_position
			fireball_instance.global_position = fire_ball_pos)
		#get_tree().get_root().add_child(fireball_instance)
		
		#
#func step_shake_cam():
	#Events.shake_camera()
