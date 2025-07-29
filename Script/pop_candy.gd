extends Area3D
signal pop_candy_speedup

func _process(delta: float) -> void:
	$Sprite3D/AnimationPlayer.play()

func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		body.powerup("pop_candy")
		print("POWERUP.")
		queue_free()
