extends Area3D

func _process(delta: float) -> void:
	$Sprite3D/AnimationPlayer.play()
func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		body.powerup("chocolate")
		print("HEAL POWER.")
		queue_free()
