extends StaticBody3D
@onready var collision = $CollisionShape3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.contador == 0:
		collision.disabled = true
