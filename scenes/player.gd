extends CharacterBody2D


#const SPEED = 300.0
const JUMP_ACCELERATION := -2500
const JUMP_MAX_VELOCITY := -600.0
const FALL_MAX_VELOCITY := 600.0
const  GRAVITY := 1200


func _physics_process(delta: float) -> void:
	if is_on_floor():
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
		

	# Handle jump.
	if Input.is_action_pressed("jump"):
		velocity.y += JUMP_ACCELERATION * delta 
		
		if velocity.y < JUMP_MAX_VELOCITY:
			velocity.y = JUMP_MAX_VELOCITY

	move_and_slide()
