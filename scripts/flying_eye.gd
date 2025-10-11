extends Monster

func _get_animator() -> AnimatedSprite2D:
	return $AnimatedSprite2D


func _get_attack_animation_name() -> String:
	const ATTACK_STRINGS: Array[String] = ["bite_attack", "spin_attack"]
	var chosen_animation: String = ATTACK_STRINGS[randi() % ATTACK_STRINGS.size()]
	
	match chosen_animation:
		"bite_attack":
			$BiteAudioStreamPlayer/BiteTimer.start()
		"spin_attack":
			$FlyAudioStreamPlayer/FlyTimer.start()
	
	return  chosen_animation
	
func _get_idle_animation_name() -> String:
	return "idle"

func _get_is_flying() -> bool:
	return true


func _on_bite_timer_timeout() -> void:
	$BiteAudioStreamPlayer.play()


func _on_fly_timer_timeout() -> void:
	$FlyAudioStreamPlayer.play()
