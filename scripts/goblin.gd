extends Monster

func _get_animator() -> AnimatedSprite2D:
	return $AnimatedSprite2D
	
func _get_attack_animation_name() -> String:
	return "attack"

func _get_idle_animation_name() -> String:
	return "idle"
	
func _get_is_flying() -> bool:
	return false
