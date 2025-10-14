extends WeaponsManager
@onready var marker_3d: Marker3D = $Marker3D
@onready var space_cannon: AudioStreamPlayer3D = $"Space-cannon"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire_delay: Timer = $fire_delay

var bullet_scene: PackedScene = load("res://Scenes/rocket.tscn")
func _physics_process(delta: float) -> void:
	if animation_player:
		animation_player.queue("rocket_anim/idle")
	if space_cannon.playing:
		Globals.is_audio_playing = true
	if Input.is_action_just_pressed("Left-Click") and have_ammo and can_shoot:
		animation_player.play("rocket_anim/attack")
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		space_cannon.play()
		can_shoot = false
		fire_delay.start()
		#for enemies in bullet_scene.get_overlapping_bodies():
			#if enemies.has_method("calcularDano"):
				#get_parent().get_parent().add_shake(0.5)
				#enemies.calcularDano(50)
		bullet.rotation.y = rotation.y
		bullet.global_position = marker_3d.global_position
		bullet.global_transform.basis.x = global_transform.basis.x
		bullet.global_transform.basis.y = global_transform.basis.y
		bullet.global_transform.basis.z = global_transform.basis.z
	if Input.is_action_just_pressed('Reload') && have_ammo && can_reload:
		animation_player.play("rocket_anim/reload")
		can_reload = false
func _on_spacecannon_finished() -> void:
		Globals.is_audio_playing = false


func _on_animation_player_animation_changed(reload, idle) -> void:
	await get_tree().create_timer(2).timeout
	can_reload = true


func _on_animation_player_reload_attack_changed(reload, attack) -> void:
	await get_tree().create_timer(2).timeout
	can_reload = true


func _on_fire_delay_timeout() -> void:
	can_shoot = true
