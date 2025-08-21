extends Node
@onready var shotgun_area = $"blaster-r2/Area3D"
var orphan = false

func _physics_process(delta: float) -> void:
	pass
func _on_enemy_on_death() -> void:
	orphan = true
