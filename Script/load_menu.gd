extends Control

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Esc"):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
