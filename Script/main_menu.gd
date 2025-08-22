extends Control

func _ready() -> void:
	Globals.pop_candy_powerup = false
	Globals.chiclete_powerup = false
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/tutorial_info.tscn")


func _on_load_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/load_menu.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
