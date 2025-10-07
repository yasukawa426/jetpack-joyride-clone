extends Node

var screen_size: Vector2i
## Foreground and background current position
var foreground_scroll = 0
## Ground scroll speed
var running_speed: int = 7


## Wether we are in a run
var running := false
var loaded := false


var score: float = 0
var highscore := 0


#TODO: Change some variable to global

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	
	loaded = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not running:
		$Background._set_scrolling_speed(0)
		
	
	if running and loaded:
		_set_score(score + (running_speed * delta * 2))
		_scroll(delta)

## Handles background and foreground scrolling
func _scroll(delta: float):
	$Background._set_scrolling_speed(running_speed)
	
	foreground_scroll += running_speed * delta * 60
	
	if foreground_scroll >= screen_size.x:
		foreground_scroll = 0
	
	$Ground.position.x = -foreground_scroll 

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_released("jump"):
		_set_running(true)
		

func _set_score(value: float) -> void:
	score = value
	$UI/ScoreLabel.set_score(int(value))

func _set_running(value: bool) -> void:
	running = value
	$Player.running = value

## Reset to initial state of the game when first started
func reset():
	$Player.reset()
	_set_score(0)
	
	_set_running(false)
	running_speed = 3
