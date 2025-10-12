extends WeaponsManager

@export var raycontainer: Node3D
@export var raio: Array[RayCast3D]

# 🔥 Damage balance — all doubled
@export var base_damage: float = 40.0         # Was 20.0 → now 40 per pellet (point-blank)
@export var min_damage: float = 8.0           # Was 4.0 → now 8 at max range
@export var max_range: float = 50.0           # Range where damage reaches minimum

func _physics_process(delta: float) -> void:
	Globals.is_audio_playing = $FIRE.playing or $RELOAD.playing

	# FIRE
	if Input.is_action_just_pressed("Left-Click") and have_ammo:
		$FIRE.play()

		for r in raycontainer.get_children():
			# Random spread per pellet
			r.target_position.x = randf_range(-8.0, 8.0)
			r.target_position.y = randf_range(-8.0, 8.0)
			r.force_raycast_update()

			if r.is_colliding():
				var target = r.get_collider()
				var hit_position = r.get_collision_point()

				# Distance from gun to hit
				var distance = r.global_position.distance_to(hit_position)

				# Linear falloff — more distance = less damage
				var t = clamp(distance / max_range, 0.0, 1.0)
				var final_damage = lerp(base_damage, min_damage, t)

				# Apply the damage
				shooting(r, final_damage)

		# Consume one shell per shot
	 

	# RELOAD
	if Input.is_action_just_pressed("Reload"):
		$RELOAD.play()

func _on_fire_finished() -> void:
	Globals.is_audio_playing = false

func _on_reload_finished() -> void:
	Globals.is_audio_playing = false
