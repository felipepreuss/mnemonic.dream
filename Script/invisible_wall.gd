extends StaticBody3D
@onready var level_block = $level_trans_block

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.contador == 0:
		level_block.disabled = true
