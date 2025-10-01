extends NPC
class_name SecretaryNPC

func _on_interact_box_body_entered(body: Node3D) -> void:
	if body.name == "player":
		set_state(CHASE)
func _on_interact_box_body_exited(body: Node3D) -> void:
	if body.name == "player":
		set_state(IDLE)

func dialogue():
		if show_dialogue:
			Dialogue.dialogo = load('res://Script/Dialogos/secretary_npc.tres')
			show_dialogue = false
