extends Area3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for bodies in get_overlapping_bodies():
		if bodies.name == "player":
			get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
