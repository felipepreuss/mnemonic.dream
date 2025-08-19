extends Area3D
signal pop_candy_speedup

func _process(delta: float) -> void:
	$Sprite3D/AnimationPlayer.play()

func _on_body_entered(body: Node3D) -> void:
	if body.name == "player"and !Globals.get_chiclete and !Globals.get_chocolate and !Globals.get_pop_candy:
		Globals.get_pop_candy = true
		body.powerup_check()
		print("POWERUP.")
		queue_free()
