extends ProgressBar

@onready var player = $"../../../.."

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	value = player.HP
