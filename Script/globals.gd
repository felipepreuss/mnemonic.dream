extends Node

var pop_candy_powerup = false
var chiclete_powerup = false
var contador = 0
var max_contador : int = 0
var get_chiclete = false
var get_pop_candy = false
var get_chocolate = false
var dialogue_end = false
var dialogue_start = false
var get_gun = false
var CabouTexto = false
var is_tutorial = false

var got_pistol = false
var got_shotgun = false
var got_smg = false
var got_dart = false
var got_rocket = false
var is_audio_playing

var boss_killed = false

#Global Score Track 
var score = 0
var score_value: int

# Global time tracking (your existing variables)
var time: float = 0.0
var minutes = 0
var seconds = 0 

# Level time tracking variables
var level_start_time: float = 0.0
var level_elapsed_time: float = 0.0
var current_scene_name: String = ""
var level_times = {}  # Dictionary to store times for each level
var is_tracking: bool = false

var levels = [
	"res://Scenes/level-1.tscn",
	"res://Scenes/level-2.tscn",
	"res://Scenes/level-3.tscn",
	"res://Scenes/level-4.tscn",
	"res://Scenes/level-5.tscn",
	"res://Scenes/level-6.tscn"
]
var current_level = 0

signal slowdown

@onready var Dialogue = "res://Scenes/dialogue.tscn"

func reset_score():
	score = 0

func reset_powerups():
	pop_candy_powerup = false
	chiclete_powerup = false
	get_gun = false

func update_time_tracking(delta: float) -> void:
	#Update global time
	time += delta
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	
	#if tracking is active
	if is_tracking:
		level_elapsed_time += delta

#start tracking time for a scene
func start_scene_time_tracking(scene_name: String = ""):
	if scene_name.is_empty():
		# Get current scene name if not provided
		current_scene_name = get_tree().current_scene.name
	else:
		current_scene_name = scene_name
	
	level_elapsed_time = 0.0
	is_tracking = true
	print("Started time tracking for scene: ", current_scene_name)

#get elapsed time in current scene
func get_scene_elapsed_time() -> float:
	return level_elapsed_time

#get formatted elapsed time (minutes:seconds)
func get_formatted_scene_time() -> String:
	var elapsed = get_scene_elapsed_time()
	var mins = floor(elapsed / 60)
	var secs = fmod(elapsed, 60)
	return "%02d:%02d" % [mins, secs]

# stop tracking and store the time
func stop_scene_time_tracking():
	if is_tracking and current_scene_name != "":
		level_times[current_scene_name] = level_elapsed_time
		print("Stopped time tracking for scene: ", current_scene_name, " - Time: ", get_formatted_scene_time())
		is_tracking = false
		current_scene_name = ""

#pause/resume time tracking
func set_time_tracking_active(active: bool):
	is_tracking = active

 
#reset all level times
func reset_all_level_times():
	level_times.clear()
func gun_reset():
	got_pistol = false
	got_shotgun = false
	got_smg = false
	got_dart = false
	got_rocket = false

func _physics_process(delta: float) -> void:
	if Globals.chiclete_powerup:
		slowdown.emit()
		await get_tree().create_timer(10)
		Globals.chiclete_powerup = false
	
	#update time tracking
	update_time_tracking(delta)
