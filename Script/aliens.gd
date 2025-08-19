extends Label

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	text = str(Globals.contador)
