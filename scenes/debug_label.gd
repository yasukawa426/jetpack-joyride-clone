extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player := $"../Player"
	
	self.text = "Player Y Speed: " + str(player.velocity.y) + "\nGravity: " + str(player.GRAVITY * delta) + "\nAcceleration: " + str(player.JUMP_ACCELERATION * delta)
