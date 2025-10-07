extends CharacterBody2D


#const SPEED = 300.0
const JUMP_VELOCITY := -1200.0
const  GRAVITY := 4200


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * delta * 60

	move_and_slide()
