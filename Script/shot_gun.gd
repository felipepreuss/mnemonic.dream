extends WeaponsManager
@export var raycontainer : Node3D
@export var raio :Array[RayCast3D]
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Left-Click"):
		for r in raycontainer.get_children():
			r.target_position.x = randi_range(10,-10)
			r.target_position.y = randi_range(10,-10)
		ray = raio[randi_range(0,5)]
		shooting(ray,20)
	print(str(current_ammo, '/', ammo))
