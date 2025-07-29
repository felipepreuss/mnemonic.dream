extends Control

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("botão da morte mortal"):
		get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
