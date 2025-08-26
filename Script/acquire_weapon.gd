extends Node3D
@onready var anim = $"Pistola (1)/AnimationPlayer"

func _physics_process(delta: float) -> void:
		anim.play("rotaaate")

func _on_weapon_get_area_body_entered(body: Node3D) -> void:
	if body.name == "player":
		Globals.get_gun = true
		queue_free()
