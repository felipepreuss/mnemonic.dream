extends Node3D
@onready var player = $SubViewportContainer/SubViewport/player

var drip_timer: Timer

func _ready() -> void:
	player.powerup_check()
	Globals.dialogue_end = true
	Globals.got_pistol = true
	Globals.got_shotgun = true
	Globals.got_smg = true
	Globals.start_scene_time_tracking()
	player.get_weapons()
 
	drip_timer = Timer.new()
	drip_timer.wait_time = 3.0   
	drip_timer.autostart = true
	drip_timer.one_shot = false  
	add_child(drip_timer)

	# signal
	drip_timer.timeout.connect(_on_drip_timer_timeout)


func _on_drip_timer_timeout() -> void:
	if randi_range(1, 10) == 5:  # 10% chance each tick
		SfxManager.drip_water.play()


func _physics_process(delta: float) -> void:
	get_tree().call_group("Enemy","update_target_location", player.global_transform.origin)


func _on_level_trans_body_entered(body: Node3D) -> void:
	if body.name == "player" and Globals.contador <= 0:
		Globals.stop_scene_time_tracking()
		body.reset_powerups()
		get_tree().change_scene_to_file.call_deferred("res://Scenes/level_complete.tscn")
