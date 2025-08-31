extends WeaponsManager

@onready var marker_3d: Marker3D = $Marker3D


var bullet_scene: PackedScene = load("res://Scenes/rocket.tscn")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Left-Click") and have_ammo:
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		#for enemies in bullet_scene.get_overlapping_bodies():
			#if enemies.has_method("calcularDano"):
				#get_parent().get_parent().add_shake(0.5)
				#enemies.calcularDano(50)
		bullet.global_transform = marker_3d.global_transform
