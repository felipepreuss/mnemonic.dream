extends WeaponsManager

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var laser_shot_1: AudioStreamPlayer3D = $"Laser-shot-1"

var bullet_scene: PackedScene = load("res://Scenes/dart_bul.tscn")

func _physics_process(delta: float) -> void:
	if laser_shot_1.playing:
		Globals.is_audio_playing = true
	if Input.is_action_just_pressed("Left-Click") and have_ammo:
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		laser_shot_1.play()
		#for enemies in bullet_scene.get_overlapping_bodies():
			#if enemies.has_method("calcularDano"):
				#get_parent().get_parent().add_shake(0.5)
				#enemies.calcularDano(50)
		bullet.global_transform = ray_cast_3d.global_transform


func _on_lasershot_1_finished() -> void:
	Globals.is_audio_playing = false
