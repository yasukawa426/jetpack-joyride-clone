extends Node
var scrolling: bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not scrolling:
		return
	
	for obstacle in get_children():
		obstacle.position.x -= $"..".running_speed * delta * 60
		
		if obstacle.position.x < -100:
			obstacle.queue_free()
