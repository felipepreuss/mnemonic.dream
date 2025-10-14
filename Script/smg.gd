extends WeaponsManager

var damage: int
@onready var blast = $SMG_fire
@onready var fire_delay = $Timer
var auto_shoot: bool = true
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	if animation_player:
		animation_player.queue("smg_anim/idle")
		
	if blast.playing:
		Globals.is_audio_playing = true
	if $SMG_reload.playing:
		Globals.is_audio_playing = true
		
	if Globals.pop_candy_powerup:
		fire_delay.wait_time = 0.03
	if Input.is_action_pressed("Left-Click") and have_ammo and auto_shoot and fire_delay:
		animation_player.play("smg_anim/attack")
		if current_ammo >= number_balas:
			auto_shoot = false
			fire_delay.start()
			
			current_ammo -= number_balas
			if current_ammo < 1:
				have_ammo = false
			shooting(ray, lerp(5, 15, 5))  
			blast.play()
			#kickb.play("recoil")
			#flash.emitting = true
			#flash.restart()
	if Input.is_action_just_pressed('Reload') && have_ammo && can_reload:
		animation_player.play("smg_anim/reload")
		$SMG_reload.play()
		can_reload = false
func _on_timer_timeout() -> void:
	auto_shoot = true


func _on_smg_fire_finished() -> void:
	Globals.is_audio_playing = false


func _on_smg_reload_finished() -> void:
	Globals.is_audio_playing = false


func _on_animation_player_animation_changed(reload, idle) -> void:
	await get_tree().create_timer(0.3).timeout
	can_reload = true
func _on_animation_player_reload_attack_changed(reload, attack) -> void:
	await get_tree().create_timer(0.3).timeout
	can_reload = true
