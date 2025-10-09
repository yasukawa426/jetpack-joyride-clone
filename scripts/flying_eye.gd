extends Monster

func _get_animator() -> AnimatedSprite2D:
	return $AnimatedSprite2D


func _get_attack_animation_name() -> String:
	const ATTACK_STRINGS: Array[String] = ["attack", "attack2"]
	
	return  ATTACK_STRINGS[randi() % ATTACK_STRINGS.size()]
	
func _get_idle_animation_name() -> String:
	return "idle"

func _get_is_flying() -> bool:
	return true
