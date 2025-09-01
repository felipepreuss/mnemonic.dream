extends Node

var current_savefile_loading: String
var save_config: ConfigFile
var is_loading: bool = false

# Store loaded data temporarily
var loaded_player_data: Dictionary = {}

func _init() -> void:
	save_config = ConfigFile.new()

func save_game(player: CharacterBody3D, weapons_manager: WeaponsManager, save_file_number: int) -> void:
	# Clear previous data
	save_config.clear()
	
	# Save metadata
	save_config.set_value("Metadata", "save_date", Time.get_date_string_from_system())
	save_config.set_value("Metadata", "save_time", Time.get_time_string_from_system())
	
	# Save current level
	var current_level = get_tree().current_scene.scene_file_path
	save_config.set_value("Level", "current_level", current_level)
	
	# Save player position and health
	save_config.set_value("Player", "position", player.global_position)
	save_config.set_value("Player", "rotation", player.global_rotation)
	save_config.set_value("Player", "health", player.HP)
	
	# Save the file
	var error = save_config.save("user://SaveFile" + str(save_file_number) + ".cfg")
	if error == OK:
		print("Game saved successfully to slot ", save_file_number)
	else:
		push_error("Failed to save game: Error " + str(error))

func load_game(save_file_number: int) -> void:
	var save_path = "user://SaveFile" + str(save_file_number) + ".cfg"
	var error = save_config.load(save_path)
	
	if error != OK:
		push_error("Failed to load save file: Error " + str(error))
		return
	
	is_loading = true
	print("Loading game from slot ", save_file_number)
	
	# Store loaded data for later application
	loaded_player_data = {
		"position": save_config.get_value("Player", "position", Vector3.ZERO),
		"rotation": save_config.get_value("Player", "rotation", Vector3.ZERO),
		"health": save_config.get_value("Player", "health", 100)
	}
	
	# Load the level first
	var level_path = save_config.get_value("Level", "current_level", "")
	if level_path and ResourceLoader.exists(level_path):
		# Change scene and apply data deferred
		get_tree().change_scene_to_file(level_path)
		call_deferred("_apply_loaded_data_deferred")
	else:
		push_error("Level file does not exist: " + level_path)
		is_loading = false

func _apply_loaded_data_deferred() -> void:
	# Wait a moment for the scene to fully load
	await get_tree().create_timer(0.1).timeout
	_apply_loaded_data()

func _apply_loaded_data() -> void:
	# Find the player in the new scene
	var player = get_tree().get_first_node_in_group("Player")
	
	if player:
		# Apply the loaded data
		player.global_position = loaded_player_data.position
		player.global_rotation = loaded_player_data.rotation
		player.HP = loaded_player_data.health
		
		print("Game loaded successfully!")
	else:
		push_error("Player node not found in the loaded scene!")
	
	is_loading = false
	loaded_player_data = {}

# Check if a save file exists
func save_file_exists(save_file_number: int) -> bool:
	return FileAccess.file_exists("user://SaveFile" + str(save_file_number) + ".cfg")

# Get save file info for UI display
func get_save_info(save_file_number: int) -> Dictionary:
	if not save_file_exists(save_file_number):
		return {}
	
	var config = ConfigFile.new()
	var error = config.load("user://SaveFile" + str(save_file_number) + ".cfg")
	
	if error != OK:
		return {}
	
	return {
		"date": config.get_value("Metadata", "save_date", "No date"),
		"time": config.get_value("Metadata", "save_time", "No time"),
		"level": config.get_value("Level", "current_level", "Unknown level").get_file(),
		"health": config.get_value("Player", "health", 0)
	}
