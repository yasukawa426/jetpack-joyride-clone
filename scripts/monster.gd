@abstract
class_name Monster 
extends Node2D

@export var has_attack: bool

signal hit

@abstract
func _get_animator() -> AnimatedSprite2D
@abstract
func _get_attack_animation_name() -> String
@abstract
func _get_idle_animation_name() -> String
@abstract 
func _get_is_flying() -> bool


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	_get_animator().animation_finished.connect(_on_attack_animation_ended.bind(_get_animator()))
	_get_animator().play(_get_attack_animation_name())
	
	#TODO: play attack sound effect


func _on_attack_animation_ended(animator: AnimatedSprite2D) -> void:
	animator.play(_get_idle_animation_name())
	


func _on_hit_area_2d_body_entered(Node2D) -> void:
	print("Player was hit!")
	hit.emit()
