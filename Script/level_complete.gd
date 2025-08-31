extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func next_level():
	if Globals.current_level < Globals.levels.size():
		get_tree().change_scene_to_file(Globals.levels[Globals.current_level])
		Globals.current_level += 1
		print(Globals.current_level)
	else:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		
func _on_next_button_pressed() -> void:
	next_level()
