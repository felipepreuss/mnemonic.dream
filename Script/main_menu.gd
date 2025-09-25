extends Control
@onready var menu_track: AudioStreamPlayer = $MENUtrack

func _ready() -> void:
	SfxManager.woah_aliens.stop()
	menu_track.play()
	Globals.reset_powerups()
	Globals.contador = 0
	if Dialogue != null:
		Dialogue.ui.visible = false
	if get_tree().paused == true:
		get_tree().paused = false
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/tutorial_info.tscn")

func _on_load_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/load_menu.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
