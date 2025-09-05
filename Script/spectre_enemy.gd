extends AlienEnemy

var bullet2 = preload("res://Scenes/bullet_enemy.tscn")
var bullet3 = preload("res://Scenes/bullet_enemy.tscn")
var bullet4 = preload("res://Scenes/bullet_enemy.tscn")
var bullet5 = preload("res://Scenes/bullet_enemy.tscn")

func _ready() -> void:
	SPEED = 10

func idle_state(delta):
	if death:
		set_state(DEATH)
	elif Globals.dialogue_end:
		set_state(SHOOT)
	var current_location = global_transform.origin
	var new_velocity = (current_location).normalized() 
	velocity = Vector3(0,0,0)
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	move_and_slide()

func chase_state(delta):
	if death:
		set_state(DEATH)
	elif retreat:
		set_state(RETREAT)
	elif attack:
		set_state(ATTACK)
	elif Globals.dialogue_start:
		set_state(IDLE)
	#visible = false
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
	elif retreat:
		set_state(RETREAT)
	elif Globals.dialogue_start:
		set_state(IDLE)
	visible = true
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	rotation.z = 0
	if can_shoot == true:
		var bala1 = bullet.instantiate()
		get_parent().get_parent().get_parent().add_child(bala1)
		bala1.rotation.y = rotation.y
		bala1.global_position = $bullet_marker.global_position
		bala1.dir = transform.basis
		bala1.dir.x = -transform.basis.x
		var bala2 = bullet2.instantiate()
		get_parent().get_parent().get_parent().add_child(bala2)
		bala2.rotation.y = rotation.y
		bala2.global_position = $bullet_marker2.global_position
		bala2.dir = transform.basis
		bala2.dir.x = -transform.basis.x
		var bala3 = bullet3.instantiate()
		get_parent().get_parent().get_parent().add_child(bala3)
		bala3.rotation.y = rotation.y
		bala3.global_position = $bullet_marker3.global_position
		bala3.dir = transform.basis
		bala3.dir.x = -transform.basis.x
		var bala4 = bullet4.instantiate()
		get_parent().get_parent().get_parent().add_child(bala4)
		bala4.rotation.y = rotation.y
		bala4.global_position = $bullet_marker4.global_position
		bala4.dir = transform.basis
		bala4.dir.x = -transform.basis.x
		var bala5 = bullet5.instantiate()
		get_parent().get_parent().get_parent().add_child(bala5)
		bala5.rotation.y = rotation.y
		bala5.global_position = $bullet_marker5.global_position
		bala5.dir = transform.basis
		bala5.dir.x = -transform.basis.x
		can_shoot = false
		set_state(CHASE)

func _on_alien_death_finished() -> void:
	Globals.contador -= 1
	print("inimigos",Globals.contador)
	queue_free()
