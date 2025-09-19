extends AlienEnemy
class_name Clone
var player_moving = false

const JUMP_VELOCITY = 4.5
const ACCELERATION = 15.0
const AIR_ACCELERATION = 5.0
const FRICTION = 15.0
const AIR_FRICTION = 2.0

func _ready():
	Globals.max_contador += 1
	Globals.contador += 1
	Globals.slowdown.connect(on_slowdown)
	vida += 666
	score_value += 666
	SPEED += 6.66

func _physics_process(delta: float) -> void:
	match current_state:
		IDLE:
			idle_state(delta)
		CHASE:
			chase_state(delta)
		ATTACK:
			attack_state(delta)
		DEATH:
			death_state(delta)
		SHOOT:
			shoot_state(delta)
		ANGRY:
			angry_state(delta)
	if player.velocity.x > 0:
		player_moving = true
		$movement_delay.start()
func chase_state(delta):
	if death:
		set_state(DEATH)
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
	move_and_slide()
func shoot_state(delta):
	if death:
		set_state(DEATH)
	elif Globals.dialogue_start:
		set_state(IDLE)

	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backwards")
	var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# Apply movement with different ground/air physics
	if is_on_floor():
		if direction:
			lerp(velocity.z, direction.z, SPEED)
			velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
			velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
		else:
			# Apply friction when not moving
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
			velocity.z = move_toward(velocity.z, 0, FRICTION * delta)
	else:
		# Air control
		if direction:
			velocity.x = move_toward(velocity.x, direction.x * SPEED, AIR_ACCELERATION * delta)
			velocity.z = move_toward(velocity.z, direction.z * SPEED, AIR_ACCELERATION * delta)
		else:
			# Less friction in air
			velocity.x = move_toward(velocity.x, 0, AIR_FRICTION * delta)
			velocity.z = move_toward(velocity.z, 0, AIR_FRICTION * delta)

	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	move_and_slide()
	if can_shoot == true:
		var bala = bullet.instantiate()
		#bala.transform.basis = transform.basis
		get_parent().get_parent().get_parent().add_child(bala)
		bala.rotation.y = rotation.y
		bala.global_position = $bullet_marker.global_position
		bala.dir = transform.basis
		bala.dir.x = -transform.basis.x
		bala.SPEED = Vector3(0, 0, -12)
		can_shoot = false

func angry_state(delta) -> void:
	pass
func _on_alien_death_finished() -> void:
		Globals.contador -= 1
		print("inimigos",Globals.contador)
		Globals.score += score_value
		print("score",Globals.score)
		queue_free()
		
func _on_movement_delay_timeout() -> void:
	pass # Replace with function body.

func _on_player_body_entered(body: Node3D) -> void:
	if body.name == "player":
		switch_to_shoot()
