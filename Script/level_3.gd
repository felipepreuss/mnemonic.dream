extends Node3D
@onready var player = $SubViewportContainer/SubViewport/player

func _ready() -> void:
	player.powerup_check()
func _on_level_trans_body_entered(body: Node3D) -> void:
	if body.name == "player" and Globals.contador <= 0:
		body.reset_powerups()
		get_tree().change_scene_to_file.call_deferred("res://Scenes/level_complete.tscn")
