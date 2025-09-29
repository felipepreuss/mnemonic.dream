extends Label
@onready var player = $"../../../.."

func _ready() -> void:
	if player != null:
		player.boss_bar_visible.connect(on_boss_bar_visible)

func on_boss_bar_visible():
	if player.boss != null:
		text = player.boss.boss_name
