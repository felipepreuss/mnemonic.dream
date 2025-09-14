extends ProgressBar

@onready var player = $"../../../.."
@onready var boss_healthbar: ColorRect = $".."

func _physics_process(delta: float) -> void:
	if player.boss != null:
		value = player.boss.vida
	else:
		boss_healthbar.visible = false
		
