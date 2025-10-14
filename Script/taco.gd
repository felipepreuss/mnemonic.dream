extends WeaponsManager

@onready var animation_player = $"Taco de baseball/AnimationPlayer"
@onready var hitbox = $"Taco de baseball/Area3D"
@onready var hit: AudioStreamPlayer3D = $SeZuburi
@onready var parry_box: CollisionShape3D = $parry_area/parry_box

var can_hit = true
var can_parry = true
var parry = false
var is_parrying = false

func _ready() -> void:
	parry_box.disabled = true
func _physics_process(delta):
	if animation_player:
		animation_player.queue("bat_anim/idle")
	if Input.is_action_pressed("Left-Click") && melee:
		if is_parrying:
			animation_player.queue("bat_anim/attack")
		else:
			animation_player.play("bat_anim/attack")
			for enemies in hitbox.get_overlapping_bodies():
				if enemies.has_method("calcularDano"):
					if can_hit:
						get_parent().get_parent().add_shake(0.5)
						enemies.calcularDano(50)
						hit.play()
						can_hit = false
				else:
					pass
	if Input.is_action_just_pressed("Right-Click") && melee && can_parry:
			animation_player.play("bat_anim/parry")
			parry_box.disabled = false
			is_parrying = true
			can_parry = false

func _on_animation_player_animation_changed(attack, idle) -> void:
	can_hit = true

func _on_parry_animation_changed(parry, idle) -> void:
	parry_box.disabled = true
	is_parrying = false
	can_parry = false

func _on_parry_delay_timeout() -> void:
	can_parry = true


func _on_parry_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("Bullet"):
		$parry_audio.play()
