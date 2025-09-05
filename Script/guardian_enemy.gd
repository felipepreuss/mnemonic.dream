extends BaseEnemy

func _on_attack_box_body_entered(body: Node3D) -> void:
	if body.name == "player":
			body.HP -= 30
