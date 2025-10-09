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
var dead := false


func _ready() -> void:
	screen_size = get_window().size


func _physics_process(delta: float) -> void:
	# 
	if not running and not dead:
		$AnimatedSprite2D.play("idle")
		return
		
	if is_on_floor():
		$AnimatedSprite2D.speed_scale = 1
		$AnimatedSprite2D.play("run")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
		if velocity.y > FALL_MAX_VELOCITY:
			velocity.y = FALL_MAX_VELOCITY
		
		if velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		else:	
			$AnimatedSprite2D.play("fall")
		
		# lets scale animation speed based on y velocity - we get the current percentage of the maximum value and then multipiply by maximum speed scale we want i.e 2
		$AnimatedSprite2D.speed_scale = (abs(velocity.y) / abs(JUMP_MAX_VELOCITY)) * 2

	# Handle jump.
	if Input.is_action_pressed("jump"):
		velocity.y += JUMP_ACCELERATION * delta 
		
		if velocity.y < JUMP_MAX_VELOCITY:
			velocity.y = JUMP_MAX_VELOCITY

	move_and_slide()
	position.y = clampi(position.y, 0, screen_size.y)
	

# Resets player status
func reset():
	running = false
	dead = false
