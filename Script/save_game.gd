extends Node

var save_config : ConfigFile
var current_savefile : String
var is_loading: bool = false

func _init() -> void:
	pass
func save_game(player: Node3D, level_path: String, save_file_number: int) -> void:
	pass
func load_game(save_file_number: int):
	pass
func _apply_loaded_data():
	pass
