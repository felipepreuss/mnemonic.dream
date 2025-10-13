extends ProgressBar

@onready var player = $"../../../.."
@onready var boss_healthbar: ColorRect = $".."
@onready var label: Label = $Label
var got_boss_health = false

func _ready() -> void:
	if player != null:
		player.boss_bar_visible.connect(on_boss_bar_visible)
	boss_healthbar.visible = false
func _physics_process(delta: float) -> void:
	if player.boss != null:
		value = player.boss.vida
	else:
		boss_healthbar.visible = false
func on_boss_bar_visible():
	boss_healthbar.visible = true
	if player.boss != null and got_boss_health == false:
		max_value = player.boss.vida
		print(player.boss.boss_name)
		got_boss_health = true
