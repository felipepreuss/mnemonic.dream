extends BaseEnemy

func _ready():
	Globals.max_contador += 1
	Globals.contador += 1
	score_value = 170
	Globals.slowdown.connect(on_slowdown)
	
func _on_attack_box_body_entered(body: Node3D) -> void:
	if !retreat:
		if body.name == "player":
				body.HP -= 20
				body.add_screen_shake(0.6)
