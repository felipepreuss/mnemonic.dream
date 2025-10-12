extends WeaponsManager

@onready var animation_player = $"Taco de baseball/AnimationPlayer"
@onready var hitbox = $"Taco de baseball/Area3D"
@onready var hit: AudioStreamPlayer3D = $SeZuburi
var can_hit = true

func _physics_process(delta):

	if Input.is_action_pressed("Left-Click") && melee:
		animation_player.play("attack")
		for enemies in hitbox.get_overlapping_bodies():
			if enemies.has_method("calcularDano"):
				if can_hit:
					get_parent().get_parent().add_shake(0.5)
					enemies.calcularDano(50)
					hit.play()
					can_hit = false
				else:
					pass
		if animation_player:
			animation_player.queue("idle")
func _on_area_3d_body_entered(body):
	pass # Replace with function body.





func _on_animation_player_animation_changed(attack, idle) -> void:
	can_hit = true
