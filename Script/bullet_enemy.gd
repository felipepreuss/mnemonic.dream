extends CharacterBody3D

var SPEED = 5

func _ready():
	$Timer
	
func _process(delta: float) -> void:
	position += Vector3(0,0,-SPEED) * delta
	
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player":
		print("Hit!")
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
