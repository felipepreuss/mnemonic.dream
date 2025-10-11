extends Label

@onready var player = $"../../../.."

func _physics_process(delta: float) -> void:
	if player.HP <= 50:
		add_theme_color_override("font_color", Color(1, 0, 0)) # red
	else:
		add_theme_color_override("font_color", Color(1, 1, 1)) # white
	text = str(player.HP)
