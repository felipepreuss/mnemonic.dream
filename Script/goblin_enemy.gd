extends AlienEnemy

func _ready() -> void:
	SPEED = 5.0
	vida = 75
	Globals.max_contador += 1
	Globals.contador += 1
	Globals.slowdown.connect(on_slowdown)
func chase_state(delta):
	if death:
		set_state(DEATH)
	elif retreat:
		set_state(RETREAT)
	elif attack:
		set_state(ATTACK)
	elif Globals.dialogue_start:
		set_state(IDLE)
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = new_velocity
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	if can_shoot == true:
		var bala = bullet.instantiate()
		#bala.transform.basis = transform.basis
		get_parent().get_parent().get_parent().add_child(bala)
		bala.rotation.y = rotation.y
		bala.global_position = $bullet_marker.global_position
		bala.dir = transform.basis
		bala.dir.x = -transform.basis.x
		can_shoot = false
	move_and_slide()

func on_slowdown() -> void:
	if Globals.chiclete_powerup:
		SPEED = 0.5
		if Globals.chiclete_powerup and get_tree():
			await get_tree().create_timer(10).timeout
			SPEED = 5.0
