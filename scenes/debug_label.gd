extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var label_text = ""
	var player := $"../../Player"
	
	label_text = "Fps: " + str(int(Engine.get_frames_per_second()))
	
	if player:
		label_text += "\nPlayer Y Speed: " + str(player.velocity.y) + "\nGravity: " + str(player.GRAVITY * delta) + "\nAcceleration: " + str(player.JUMP_ACCELERATION * delta)
	
	self.text = label_text
