extends Control


var levels = [
	"res://Scenes/level-1.tscn",
	"res://Scenes/level-2.tscn",
	"res://Scenes/level-3.tscn",
	"res://Scenes/level-4.tscn"
]

var current_level := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func next_level():
	if current_level < levels.size():
		get_tree().change_scene_to_file(levels[current_level])
		current_level += 1
	else:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_next_button_pressed() -> void:
	next_level() # Replace with function body.
