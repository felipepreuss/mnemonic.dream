extends Area3D

func _process(delta: float) -> void:
	$Sprite3D/AnimationPlayer.play()

func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		body.powerup("chiclete")
		print("ENEMY SLOWDOWN.")
		Globals.chiclete_powerup = true
		queue_free()
