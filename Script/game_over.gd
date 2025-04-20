extends Control


func _on_load_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/load_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
