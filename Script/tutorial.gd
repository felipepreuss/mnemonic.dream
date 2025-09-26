extends Node3D
@onready var player = $SubViewportContainer/SubViewport/player
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	get_tree().call_group("Enemy","update_target_location", player.global_transform.origin)
func _process(float):
	if Dialogue.dialogo.id < 3:
		if not SfxManager.woah_aliens.playing:
			SfxManager.woah_aliens.play()
	elif Dialogue.dialogo.id == 3:
		if SfxManager.woah_aliens.playing:
			SfxManager.woah_aliens.stop()
func _ready():
	Dialogue.dialogo = load('res://Script/Dialogos/0.tres')
	Dialogue.player = player
	Globals.is_tutorial = true
	Globals.start_scene_time_tracking()
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player" and Globals.contador <= 0:
		body.reset_powerups()
		Globals.stop_scene_time_tracking()
		get_tree().change_scene_to_file.call_deferred("res://Scenes/level_complete.tscn")
