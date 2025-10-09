extends Node

### Constants
const PLAYER_START_POSITION := Vector2i(133, 424)
const START_RUNNING_SPEED := 7
const MAX_RUNNING_SPEED := 25

const OBSTACLE_SPAWN_X := 1600
const OBSTACLE_TYPES: Array[String] = ["res://scenes/obstacles/flying_eye.tscn", "res://scenes/obstacles/goblin.tscn"]

const START_TIMER_LENGTH := 3
const MINIMUM_TIMER_LENGTH := 0.5

const START_TIMER_THRESHOLD: int = 100
const START_SPAWNER_THRESHOLD: int = 350

const SAVE_PATH := "user://highscore.json"

var screen_size: Vector2i



### Flags

## Wether we are in a run
var running := false
var loaded := false

### Variables

## Foreground and background current position
var foreground_scroll = 0
## Ground scroll speed
var running_speed: float = 7

var score: float = 0
var highscore := 0

#Amount of score needed to 
#decrease timer maximum time (increasing spawn rate)
var next_timer_threshold: int
#increase number of timer spawners
var next_spawner_threshold: int

#TODO: Change some variables to global

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	
	next_spawner_threshold = START_SPAWNER_THRESHOLD
	next_timer_threshold = START_TIMER_THRESHOLD
	
	_load()
	
	if OS.is_debug_build():
		$UI/DebugLabel.show()
	else:
		$UI/DebugLabel.hide()
	
	loaded = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not running:
		$Background._set_scrolling_speed(0)
		
		for timer in $Timers.get_children():
			timer.stop()
		
		#for obstacle in $Obstacles.get_children():
		#	obstacle.queue_free()
		
	
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

func _input(event: InputEvent) -> void:
	if $Player.get_dead() == true:
		return

	if not running:
		if event.is_action_released("jump"):
			$AnimationPlayer.play("day_cycle")
			$UI/StartLabel.hide()
			_set_running(true)
			_add_new_timer()
		

func _set_score(value: float) -> void:
	score = value
	$UI/ScoreLabel.set_score(int(value))
	$UI/GameoverUI/OverScoreLabel.set_score(int(value))
	
	if score > next_timer_threshold:
		next_timer_threshold += START_TIMER_THRESHOLD
		_update_running_difficulty()
	
	if score > next_spawner_threshold:
		next_spawner_threshold += START_SPAWNER_THRESHOLD
		_update_spawner_difficulty()

func _set_highscore(value: int) -> void:
	if value > highscore:
		highscore = int(value)
		$UI/GameoverUI/OverHighScoreLabel.set_high_score(value)
		_save()	
	

func _set_running(value: bool) -> void:
	running = value
	$Player.running = value
	
	if running == true:
		for timer in $Timers.get_children():
			timer.start()		

## Reset to initial state of the game when first started
func reset():
	$Player.reset()
	$Player.position = PLAYER_START_POSITION
	running_speed = START_RUNNING_SPEED
	
	for obstacle in $Obstacles.get_children():
			obstacle.queue_free()
			
	for timer in $Timers.get_children():
		timer.queue_free()
	
	$Obstacles.scrolling = true
	$UI/StartLabel.show()
	$UI/GameoverUI.hide()
	
	next_timer_threshold = START_TIMER_THRESHOLD
	next_spawner_threshold = START_SPAWNER_THRESHOLD

	$AnimationPlayer.play("RESET")
	
	_set_score(0)
	_set_running(false)

#TODO: with time, create more timers that connect to this method, increasing the difficulty
func _on_obstacle_timer_timeout() -> void:
	# Picks one random obstacle and loads it
	var obstacle_scene: PackedScene = load(OBSTACLE_TYPES[randi() % OBSTACLE_TYPES.size()])
	var newObstacle: Monster = obstacle_scene.instantiate()
	newObstacle.hit.connect(_on_obstacle_hit)
	
	var obstacle_spawn_y
	if newObstacle._get_is_flying():
		# if can fly spawn at the air
		obstacle_spawn_y = randi_range(60, 463) 
	else:
		# if cant fly spawns at the ground
		obstacle_spawn_y = 500
	
	
	newObstacle.position = Vector2(OBSTACLE_SPAWN_X, obstacle_spawn_y)
	
	
	$Obstacles.add_child(newObstacle)


func _on_obstacle_hit() -> void:
	$Player.set_dead(true)
	$Obstacles.scrolling = false
	_set_running(false)
	_set_highscore(score)
	
	$AnimationPlayer.pause()
	
	$UI/GameoverUI.show()

#TODO: style all labels


func _on_button_pressed() -> void:
	reset()

func _save():
	print("Saving to :" + OS.get_user_data_dir())
	var data := {
		"highscore" = highscore
	}
	
	var json_string := JSON.stringify(data)
	
	#open the file for writing as a FileAccess object
	var file_access := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	if not file_access:
		#somethign went very wrong here
		print("OPSIE, for some reason we couldn't save your data: ", FileAccess.get_open_error())
		return
	
	file_access.store_line(json_string)
	file_access.close()


func _load():
	#nothing to load, exits
	if not FileAccess.file_exists(SAVE_PATH):
		_set_highscore(0)
		return
	
	# opens the file for reading
	var file_access := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_string := file_access.get_line()
	file_access.close()
	
	var json := JSON.new()
	var error := json.parse(json_string)
	if error:
		print("JSON PARSE ERROR BRUIH: ", json.get_error_message(), " in ", json_string,)
		return
	
	#gets the highscore or 0 
	var data:Dictionary = json.data
	_set_highscore(data.get("highscore", 0))
	print("Loaded highscore: " + str(highscore))


func _update_running_difficulty():
	running_speed += 0.5

func _update_spawner_difficulty():
	_add_new_timer()	

func _add_new_timer() -> void:
	var timer := Timer.new()
	$Timers.add_child(timer)
	timer.wait_time = START_TIMER_LENGTH
	timer.one_shot = false
	timer.start()
	timer.timeout.connect(_on_obstacle_timer_timeout)
