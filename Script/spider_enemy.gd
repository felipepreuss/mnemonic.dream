extends BaseEnemy
class_name SpiderEnemy
var max_speed = 15
var run_speed = 5
var min_speed = 4
@onready var AttackBox = $attack_box
var can_hit = false
var enemy_spider_material = load("res://Scenes/spider_enemy.tscn::StandardMaterial3D_tyhe3")
var bullet = preload("res://Scenes/enemy_projectile.tscn")
var can_shoot = false

func _ready():
	Globals.max_contador += 1
	Globals.contador += 1
	score_value = 120
	Globals.slowdown.connect(on_slowdown)

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
	if Globals.contador <= 2 or Globals.boss_killed:
		print(Globals.contador)
		enemy_spider_material.set_stencil_mode(2)
		enemy_spider_material.stencil_color = Color(255,255,0)
	if run_speed > max_speed:
		run_speed = max_speed
	elif run_speed < min_speed:
		run_speed = min_speed
	else:
		run_speed -= 0.5
	for body in $shoot_box.get_overlapping_bodies():
			if body.name =="player":
				switch_to_shoot()
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
	var new_velocity = (next_location - current_location).normalized() * run_speed
	velocity = new_velocity
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	move_and_slide()

func attack_state(delta):
	if death:
		set_state(DEATH)
	elif retreat:
		set_state(RETREAT)
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
		bala.SPEED = Vector3(0, 0, -15)
		can_shoot = false
		switch_to_chase()
		
func _on_bullet_timer_timeout() -> void:
	if current_state == 1:
		can_shoot = true
func switch_to_attack() -> void:
	if death:
		set_state(DEATH)
	elif retreat:
		set_state(RETREAT)
	else:
		set_state(ATTACK)

func calcularDano(dano:int):
	vida -= dano
	run_speed += dano/10
	$alienHurt.play()
	if vida <= 0:
		death = true
	elif vida <= 100:
		retreat = true

func _on_attack_box_body_entered(body: Node3D) -> void:
	if body.name == "player":
			body.HP -= 15

func switch_to_shoot() -> void:
	if death:
		set_state(DEATH)
	elif retreat:
		set_state(RETREAT)
	elif Globals.dialogue_start:
		set_state(IDLE)
	elif can_shoot:
		set_state(SHOOT)
	elif !can_shoot:
		set_state(CHASE)
func switch_to_chase() -> void:
	if death:
		set_state(DEATH)
	elif retreat:
		set_state(RETREAT)
	elif Globals.dialogue_start:
		set_state(IDLE)
	elif can_shoot:
		set_state(SHOOT)
	else:
		set_state(CHASE)
func on_slowdown() -> void:
	if Globals.chiclete_powerup:
		min_speed = 0.5
		run_speed = 0.5
		max_speed = 0.5
		if Globals.chiclete_powerup and get_tree():
			await get_tree().create_timer(10).timeout
			min_speed = 4
			run_speed = 5
			max_speed = 15
