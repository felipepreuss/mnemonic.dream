extends CharacterBody3D
@export var player : CharacterBody3D
var vida = 200
var SPEED = 3.0
var accel = 10
#maquina de estado
var retreat = false
var death = false
var attack = false
var bullet = preload("res://Scenes/bullet_enemy.tscn")

#@onready var slowdown_check = $slowdown_check

var chiclete_powerup_scene = preload("res://Scenes/chiclete_powerup.tscn")
var pop_candy_powerup_scene = preload("res://Scenes/pop_candy.tscn")
var chocolate_powerup_scene = preload("res://Scenes/chocolate_powerup.tscn")

var can_shoot = false
@onready var nav_agent = $NavigationAgent3D
enum {IDLE, CHASE,ATTACK,RETREAT,DEATH, SHOOT}
var current_state = 0
var state_start = true
signal on_death

func _ready():
	Globals.contador += 1
	Globals.slowdown.connect(on_slowdown)
	#if player != null:
		#player.switch_to_shoot.connect(on_switch_to_shoot)
		#player.switch_to_chase.connect(on_switch_to_chase)
	#if slowdown_check != null:
		#slowdown_check.slowdown.connect(on_slowdown)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	scale *= 1.003
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

func idle_state(delta):
	if death:
		set_state(DEATH)
	elif Globals.dialogue_end:
		set_state(CHASE)
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
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
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

func retreat_state(delta):
	if death:
		set_state(DEATH)
	elif attack:
		set_state(ATTACK)
	elif Globals.dialogue_start:
		set_state(IDLE)
		
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * (-SPEED)
	if is_on_floor():
		velocity = new_velocity
		look_at(player.global_transform.origin, Vector3.UP)
		rotation.z = 0
		rotation.x = 0
	else:
		velocity += get_gravity() * delta
	move_and_slide()
	
func death_state(delta):
	emit_signal("on_death")
	$alienDeath.play() 

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
		

func update_target_location(target_location):
	nav_agent.set_target_position(target_location)

func calcularDano(dano:int):
	vida -= dano
	$alienHurt.play()
	if vida <= 0:
		Globals.contador -= 1
		print("inimigos",Globals.contador)
		death = true
	elif vida <= 100:
		retreat = true
		
func set_state(novo_estado):
	if novo_estado != current_state:
		current_state = novo_estado
		state_start = true

func _on_alien_death_finished() -> void:
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
		queue_free()
func _on_bullet_timer_timeout() -> void:
	can_shoot = true
func switch_to_shoot() -> void:
	if death:
		set_state(DEATH)
	elif retreat:
		set_state(RETREAT)
	else:
		set_state(SHOOT)

func switch_to_chase() -> void:
	if death:
		set_state(DEATH)
	elif retreat: 
		set_state(RETREAT)
	else: 
		set_state(CHASE)

func on_slowdown() -> void:
	if Globals.chiclete_powerup:
		SPEED = 0.5
		if Globals.chiclete_powerup and get_tree():
			await get_tree().create_timer(10).timeout
			SPEED = 3.0
