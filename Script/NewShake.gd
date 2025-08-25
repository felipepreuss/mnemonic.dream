# MinimalScreenShake.gd
extends Camera3D

var shake: float = 0.0
var original_pos: Vector3

func _ready():
	original_pos = position

func add_shake(amount: float):
	if shake <= 0:
		shake += amount

func _process(delta):
	if shake > 0:
		position = original_pos + Vector3(
			randf_range(-shake, shake),
			randf_range(-shake, shake),
			0
		)
		shake -= delta * 2.0
	else:
		position = original_pos
		shake = 0.0
