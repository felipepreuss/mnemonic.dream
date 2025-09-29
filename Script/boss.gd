extends ProgressBar

@onready var player = $"../../../.."
@onready var boss_healthbar: ColorRect = $".."
@onready var label: Label = $Label

func _ready() -> void:
	if player != null:
		player.boss_bar_visible.connect(on_boss_bar_visible)
	boss_healthbar.visible = false
func _physics_process(delta: float) -> void:
	if player.boss != null:
		value = player.boss.vida
func on_boss_bar_visible():
	boss_healthbar.visible = true
	if player.boss != null:
		max_value = player.boss.vida
		print(player.boss.boss_name)
