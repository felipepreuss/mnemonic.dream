extends WeaponsManager

var damage: int
@onready var blast = $SMG_fire
@onready var fire_delay = $Timer
var auto_shoot: bool = true

func _physics_process(delta: float) -> void:
	if blast.playing:
		Globals.is_audio_playing = true
	if $SMG_reload.playing:
		Globals.is_audio_playing = true
	if Globals.pop_candy_powerup:
		fire_delay.wait_time = 0.01
	if Input.is_action_pressed("Left-Click") and have_ammo and auto_shoot and fire_delay:
		if current_ammo >= number_balas:
			auto_shoot = false
			fire_delay.start()
			
			current_ammo -= number_balas
			if current_ammo < 1:
				have_ammo = false
			shooting(ray, lerp(5, 20, 5))  
			blast.play()
			#kickb.play("recoil")
			#flash.emitting = true
			#flash.restart()
	if Input.is_action_just_pressed('Reload') and have_ammo:
		$SMG_reload.play()
		
func _on_timer_timeout() -> void:
	auto_shoot = true


func _on_smg_fire_finished() -> void:
	Globals.is_audio_playing = false


func _on_smg_reload_finished() -> void:
	Globals.is_audio_playing = false
