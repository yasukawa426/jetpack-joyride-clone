extends Node2D

const BACKGROUND_SPEED = -6


## Set scrolling speed based on speed passed
func _set_scrolling_speed(speed: int) -> void:
	$ParallaxClouds.autoscroll.x = BACKGROUND_SPEED * speed
	$ParallaxMountains.autoscroll.x = (BACKGROUND_SPEED * 2) * speed
	$ParallaxTrees.autoscroll.x = (BACKGROUND_SPEED * 4) * speed
