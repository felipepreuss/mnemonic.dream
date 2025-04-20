extends Control


func _on_apply_button_pressed() -> void:
	pass


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
