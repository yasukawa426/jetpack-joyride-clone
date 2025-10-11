extends CharacterBody2D


#const SPEED = 300.0
const JUMP_ACCELERATION := -2500
const JUMP_MAX_VELOCITY := -600.0
const FALL_MAX_VELOCITY := 600.0
const  GRAVITY := 1200

var screen_size: Vector2i

## Wheter we are in a run
var running := false
## Are we dead????
var _dead := false


func _ready() -> void:
	screen_size = get_window().size


func _physics_process(delta: float) -> void:
	#Stuff here happens if the player is alive or not
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
		if velocity.y > FALL_MAX_VELOCITY:
			velocity.y = FALL_MAX_VELOCITY

	$AnimatedSprite2D.speed_scale = 1
	move_and_slide()
	position.y = clampi(position.y, 0, screen_size.y)
	
	#stuff to do only if dead
	if _dead:
		#right now, nothing. so we are returning instead of having a nested if else
		return
		
	#stuff to do only if alive
	_handle_input(delta)
		
	if not running:
		if not $AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play("idle")
		return
		
	if is_on_floor():
		$AnimatedSprite2D.play("run")
	else:
		if velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		else:	
			$AnimatedSprite2D.play("fall")
		# lets scale animation speed based on y velocity - we get the current percentage of the maximum value and then multipiply by maximum speed scale we want i.e 2
		$AnimatedSprite2D.speed_scale = (abs(velocity.y) / abs(JUMP_MAX_VELOCITY)) * 2
	 

	
	

# Resets player status
func reset():
	running = false
	_dead = false
	$AnimatedSprite2D.play_backwards("death")
	
func set_dead(value: bool):
	if _dead == value:
		#if not changing, does nothing. just in case we proc death multiple times in a row
		return
	
	_dead = value
	
	if value == true:
		#TODO: blood effect(?), rotate?
		$AnimatedSprite2D.play("death")
		pass

func get_dead() -> bool:
	return _dead

func _handle_input(delta: float):
	# Handle jump.
	if Input.is_action_pressed("jump"):
		velocity.y += JUMP_ACCELERATION * delta 
		
		if velocity.y < JUMP_MAX_VELOCITY:
			velocity.y = JUMP_MAX_VELOCITY


#Whenever the frame changes, we check if its a footstep frame in the run animation and play the sound if it is
func _on_animated_sprite_2d_frame_changed() -> void:
	var animator: AnimatedSprite2D = $AnimatedSprite2D
	var footstep_player: AudioStreamPlayer = $FootstepsAudioStreamPlayer
	const FOOTSTEP_FRAMES := [1, 6]
	var is_running_animation: bool = animator.is_playing() and animator.animation == "run"
	
	if is_running_animation and animator.frame in FOOTSTEP_FRAMES:
		footstep_player.play()
		print("Step!")
	
	else:
		footstep_player.stop()
