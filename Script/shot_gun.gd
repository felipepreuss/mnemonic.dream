extends WeaponsManager
@export var raycontainer : Node3D
@export var raio :Array[RayCast3D]
 
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Left-Click") && current_gun.have_ammo:
		for r in raycontainer.get_children():
			r.target_position.x = randi_range(10,-10)
			r.target_position.y = randi_range(10,-10)
		ray = raio[randi_range(0,5)]
		$FIRE.play()
		shooting(ray,20)
	if Input.is_action_just_pressed('Reload'):
		$RELOAD.play()
	#print(str(current_ammo, '/', ammo))
