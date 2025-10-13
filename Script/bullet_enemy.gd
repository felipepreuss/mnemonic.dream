extends CharacterBody3D

var SPEED : Vector3 = Vector3(0, 0, -8)
@export var dir : Basis

func _ready():
	$Timer

func _process(delta: float) -> void:
	velocity = SPEED * dir
	
	move_and_slide()
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player":
		print("Hit!")
		queue_free()
	elif body is CSGCombiner3D:
		queue_free()
func _on_timer_timeout() -> void:
	queue_free()


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("Parry"):
		queue_free()
