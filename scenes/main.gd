extends Node

## Foreground and background current position
var background_scroll
var foreground_scroll
## Ground scroll speed
@export var FOREGROUND_SCROLL_SPEED: int = 3
## Background scroll speed
@export var BACKGROUND_SCROLL_SPEED: = 0.5

var screen_size: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	
	foreground_scroll = 0
	background_scroll = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_scroll(delta)
	pass

## Handles background and foreground scrolling
func _scroll(delta: float):
	foreground_scroll += FOREGROUND_SCROLL_SPEED * delta * 60
	#background_scroll += BACKGROUND_SCROLL_SPEED * delta * 60
		
	if foreground_scroll >= screen_size.x:
		foreground_scroll = 0
	
	#if background_scroll >= screen_size.x:
	#	background_scroll = 0
	
	$Ground.position.x = -foreground_scroll 
	#$Background.position.x = -background_scroll
