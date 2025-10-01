extends NPC

func dialogue():
		if show_dialogue:
			Dialogue.dialogo = load('res://Script/Dialogos/urso_npc.tres')
			show_dialogue = false
