extends Control

@onready var file_1_button: Button = $VBoxContainer/FILE_1
@onready var file_2_button: Button = $VBoxContainer/FILE_2
@onready var file_3_button: Button = $VBoxContainer/FILE_3

func _ready() -> void:
	# Update button texts with save file info
	_update_save_buttons()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Esc"):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _update_save_buttons() -> void:
	# Update button texts with save file information
	var save1_info = SaveGame.get_save_info(1)
	var save2_info = SaveGame.get_save_info(2)
	var save3_info = SaveGame.get_save_info(3)
	
	if save1_info.is_empty():
		file_1_button.text = "File 1 - Empty"
	else:
		file_1_button.text = "File 1 - " + save1_info.level + " - Health: " + str(save1_info.health)
	
	if save2_info.is_empty():
		file_2_button.text = "File 2 - Empty"
	else:
		file_2_button.text = "File 2 - " + save2_info.level + " - Health: " + str(save2_info.health)
	
	if save3_info.is_empty():
		file_3_button.text = "File 3 - Empty"
	else:
		file_3_button.text = "File 3 - " + save3_info.level + " - Health: " + str(save3_info.health)

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_file_1_pressed() -> void:
	if SaveGame.save_file_exists(1):
		SaveGame.load_game(1)
	else:
		print("No save file in slot 1")

func _on_file_2_pressed() -> void:
	if SaveGame.save_file_exists(2):
		SaveGame.load_game(2)
	else:
		print("No save file in slot 2")

func _on_file_3_pressed() -> void:
	if SaveGame.save_file_exists(3):
		SaveGame.load_game(3)
	else:
		print("No save file in slot 3")

func _on_load_button_pressed():
	# This could be a general load button that loads the selected file
	pass
