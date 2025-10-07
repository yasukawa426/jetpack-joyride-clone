extends Node

### Constants
const PLAYER_START_POSITION := Vector2i(133, 424)
const START_RUNNING_SPEED := 7
const MAX_RUNNING_SPEED := 25
const OBSTACLE_SPAWN_X := 1300

const OBSTACLE_TYPES: Array[String] = ["res://scenes/obstacles/flying_eye.tscn", "res://scenes/obstacles/goblin.tscn"]

var screen_size: Vector2i



### Flags

## Wether we are in a run
var running := false
var loaded := false

### Variables

## Foreground and background current position
var foreground_scroll = 0
## Ground scroll speed
var running_speed: int = 7

var score: float = 0
var highscore := 0


#TODO: Change some variables to global

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	
	loaded = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not running:
		$Background._set_scrolling_speed(0)
		$ObstacleTimer.stop()
		
		for obstacle in $Obstacles.get_children():
			obstacle.queue_free()
		
	
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
	
	if running == true:
		$ObstacleTimer.start()		

## Reset to initial state of the game when first started
func reset():
	$Player.reset()
	$Player.position = PLAYER_START_POSITION
	running_speed = START_RUNNING_SPEED
	
	
	_set_score(0)
	_set_running(false)


func _on_obstacle_timer_timeout() -> void:
	# Picks one random obstacle and loads it
	var obstacle_scene: PackedScene = load(OBSTACLE_TYPES[randi() % OBSTACLE_TYPES.size()])
	var newObstacle: Area2D = obstacle_scene.instantiate()
	newObstacle.position = Vector2(OBSTACLE_SPAWN_X, 505)
	
	$Obstacles.add_child(newObstacle)
	
	#TODO: Adjust y spawn position based on obstacle type
	
