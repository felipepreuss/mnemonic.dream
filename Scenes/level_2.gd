extends Node3D
@onready var play = $SubViewportContainer/SubViewport/player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	get_tree().call_group("Enemy","update_target_location", play.global_transform.origin)
