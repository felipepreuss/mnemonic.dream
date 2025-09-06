extends BaseEnemy
class_name AlienEnemy

var bullet = preload("res://Scenes/bullet_enemy.tscn")
var can_shoot = false

func _physics_process(delta: float) -> void:
	match current_state:
		IDLE:
			idle_state(delta)
		CHASE:
			chase_state(delta)
		ATTACK:
			attack_state(delta)
		RETREAT:
			retreat_state(delta)
		DEATH:
			death_state(delta)
		SHOOT:
			shoot_state(delta)
func shoot_state(delta):
	if death:
		set_state(DEATH)
	elif retreat:
		set_state(RETREAT)
	elif Globals.dialogue_start:
		set_state(IDLE)
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	rotation.z = 0
	if can_shoot == true:
		var bala = bullet.instantiate()
		#bala.transform.basis = transform.basis
		get_parent().get_parent().get_parent().add_child(bala)
		bala.rotation.y = rotation.y
		bala.global_position = $bullet_marker.global_position
		bala.dir = transform.basis
		bala.dir.x = -transform.basis.x
		can_shoot = false
		#var bala = bullet.instantiate()
		#bullet.position = pos.global_position
		#bala.transform.basis = $bullet_marker.global_transform.basis
		#get_parent().add_child(bullet)
func _on_bullet_timer_timeout() -> void:
	can_shoot = true

func switch_to_shoot() -> void:
	if death:
		set_state(DEATH)
	elif retreat:
		set_state(RETREAT)
	else:
		set_state(SHOOT)

func _on_alien_death_finished() -> void:
	if !Globals.is_tutorial:
		var chiclete_powerup = chiclete_powerup_scene.instantiate()
		var chocolate = chocolate_powerup_scene.instantiate()
		var pop_candy = pop_candy_powerup_scene.instantiate()
		var rng = RandomNumberGenerator.new()
		randomize()
		var rng_powerup = rng.randi_range(1, 3)
		print(rng_powerup)
		if rng_powerup == 1:
			get_parent().add_child(chiclete_powerup)
			chiclete_powerup.global_position = $bullet_marker.global_position
		if rng_powerup == 2:
			get_parent().add_child(chocolate)
			chocolate.global_position = $bullet_marker.global_position
		if rng_powerup == 3:
			get_parent().add_child(pop_candy)
			pop_candy.global_position = $bullet_marker.global_position
		Globals.contador -= 1
		print("inimigos",Globals.contador)
		queue_free()
	else:
		Globals.contador -= 1
		print("inimigos",Globals.contador)
		queue_free()
