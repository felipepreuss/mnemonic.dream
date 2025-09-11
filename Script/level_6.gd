extends Node3D
@onready var player = $SubViewportContainer/SubViewport/player

func _ready() -> void:
	player.powerup_check()
	Globals.dialogue_end = true
	Globals.got_pistol = true
	Globals.got_shotgun = true
	Globals.got_smg = true
	Globals.got_dart = true
	Globals.got_rocket = true
	Globals.start_scene_time_tracking()
	player.get_weapons()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	get_tree().call_group("Enemy","update_target_location", player.global_transform.origin)
func _on_level_trans_body_entered(body: Node3D) -> void:
	if body.name == "player" and Globals.contador <= 0:
		Globals.stop_scene_time_tracking()
		body.reset_powerups()
		get_tree().change_scene_to_file.call_deferred("res://Scenes/level_complete.tscn")
