extends Node3D
@onready var player = $SubViewportContainer/SubViewport/player
func _ready() -> void:
	player.powerup_check()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	get_tree().call_group("Enemy","update_target_location", player.global_transform.origin)
