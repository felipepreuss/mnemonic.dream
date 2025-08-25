extends Control


func _on_apply_button_pressed() -> void:
	pass


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1152,648))
			
		1:
			DisplayServer.window_set_size(Vector2i(800,600))
		2:
			DisplayServer.window_set_size(Vector2i(640,480))
	
