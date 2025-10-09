extends Node2D

signal hit


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	var animator: AnimatedSprite2D = $GoblinArea2D/AnimatedSprite2D
	
	
	animator.animation_finished.connect(_on_attack_animation_ended.bind(animator))
	animator.play("Attack")
	
	#TODO: add attack sound effect


func _on_attack_animation_ended(animator: AnimatedSprite2D) -> void:
	animator.play("idle")
