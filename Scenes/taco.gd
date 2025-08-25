extends WeaponsManager

@onready var animation_player = $"Taco de baseball/AnimationPlayer"


func _physics_process(delta):

	if Input.is_action_pressed("Left-Click") && melee:
		animation_player.play("attack")
		
		if animation_player:
			animation_player.queue("idle")
func _on_area_3d_body_entered(body):
	pass # Replace with function body.
