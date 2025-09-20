extends WeaponsManager

@onready var laser = $AudioStreamPlayer3D
var pistol_ammo = max_ammo
func _physics_process(delta: float) -> void:
	if laser.playing:
		Globals.is_audio_playing = true
	if $Rel.playing:
		Globals.is_audio_playing = true
	if Input.is_action_just_pressed("Left-Click") && have_ammo:
		shooting(ray,lerp(5,20,5))
		laser.play()
	elif Input.is_action_just_pressed("Left-Click") && not have_ammo:
		pass
	if Input.is_action_just_pressed('Reload') && have_ammo:
		$Rel.play()


func _on_audio_stream_player_3d_finished() -> void:
	Globals.is_audio_playing = false


func _on_rel_finished() -> void:
	Globals.is_audio_playing = false
