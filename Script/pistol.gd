extends WeaponsManager

@onready var r: RayCast3D = $RayCast3D

@onready var laser = $AudioStreamPlayer3D
@export var max_range: float = 50.0
@export var base_damage: float = 40.0
@export var min_damage: float = 8.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var pistol_ammo = max_ammo
func _physics_process(delta: float) -> void:
	if animation_player:
		animation_player.queue("pistol_anim/idle")
	if laser.playing:
		Globals.is_audio_playing = true
	if $Rel.playing:
		Globals.is_audio_playing = true
	if Input.is_action_just_pressed("Left-Click") && have_ammo:
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
				laser.play()
				animation_player.play("pistol_anim/attack")
	elif Input.is_action_just_pressed("Left-Click") && not have_ammo:
		pass
	if Input.is_action_just_pressed('Reload') && have_ammo:
		$Rel.play()
		animation_player.play("pistol_anim/reload")


func _on_audio_stream_player_3d_finished() -> void:
	Globals.is_audio_playing = false


func _on_rel_finished() -> void:
	Globals.is_audio_playing = false
