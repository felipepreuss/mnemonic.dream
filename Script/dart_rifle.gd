extends WeaponsManager

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var laser_shot_1: AudioStreamPlayer3D = $"Laser-shot-1"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire_delay: Timer = $fire_delay

var bullet_scene: PackedScene = load("res://Scenes/dart_bul.tscn")

func _physics_process(delta: float) -> void:
	if animation_player:
		animation_player.queue("dart_anim/idle")
	if laser_shot_1.playing:
		Globals.is_audio_playing = true
	if Input.is_action_just_pressed("Left-Click") and have_ammo and can_shoot:
		animation_player.play("dart_anim/attack")
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		laser_shot_1.play()
		can_shoot = false
		fire_delay.start()
		bullet.global_transform = ray_cast_3d.global_transform
		
	if Input.is_action_just_pressed('Reload') && have_ammo && can_reload:
		animation_player.play("dart_anim/reload")
		can_reload = false
func _on_lasershot_1_finished() -> void:
	Globals.is_audio_playing = false


func _on_animation_player_animation_changed(reload, idle) -> void:
	await get_tree().create_timer(0.5).timeout
	can_reload = true


func _on_animation_player_reload_attack_changed(old_name: StringName, new_name: StringName) -> void:
	await get_tree().create_timer(0.5).timeout
	can_reload = true


func _on_fire_delay_timeout() -> void:
	can_shoot = true
