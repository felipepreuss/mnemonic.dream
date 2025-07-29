extends Node3D
signal slowdown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.chiclete_powerup:
		emit_slowdown()
	
func emit_slowdown():
	slowdown.emit()
	
