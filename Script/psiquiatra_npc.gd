extends NPC

func dialogue():
		if show_dialogue:
			Dialogue.dialogo = load('res://Script/Dialogos/psiquiatra_npc.tres')
			show_dialogue = false
