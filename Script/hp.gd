extends Label

@onready var player = $"../../../.."

func _physics_process(delta: float) -> void:
	text = str(player.HP)
