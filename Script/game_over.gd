extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_load_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
