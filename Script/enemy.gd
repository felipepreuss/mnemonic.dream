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
var can_shoot = false
@onready var nav_agent = $NavigationAgent3D
enum {CHASE,ATTACK,RETREAT,DEATH, SHOOT}
var current_state = 0
var state_start = true

func _ready():
	player.switch_to_shoot.connect(on_switch_to_shoot)
	player.switch_to_chase.connect(on_switch_to_chase)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match current_state:
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

func chase_state(delta):
	if death:
		set_state(DEATH)
	elif retreat:
		set_state(RETREAT)
	elif attack:
		set_state(ATTACK)
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
		
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * (-SPEED)
	if is_on_floor():
		velocity = new_velocity
		look_at(player.global_transform.origin, Vector3.UP)
		rotation.x = 0
	else:
		velocity += get_gravity() * delta
	move_and_slide()
	
func death_state(delta):
	$alienDeath.play() 

func shoot_state(delta):
	if death:
		set_state(DEATH)
	elif retreat:
		set_state(RETREAT)
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	if can_shoot == true:
		var bala = bullet.instantiate()
		add_child(bala)
		bala.global_position = $bullet_marker.global_position
		can_shoot = false
		#var bala = bullet.instantiate()
		#bullet.position = pos.global_position
		#bullet.transform.basis = pos.global_transform.basis
		#get_parent().add_child(bullet)
		

func update_target_location(target_location):
	nav_agent.set_target_position(target_location)

func calcularDano(dano:int):
	vida -= dano
	$alienHurt.play()
	if vida <= 0:
		death = true
	elif vida <= 100:
		retreat = true
		
func set_state(novo_estado):
	if novo_estado != current_state:
		current_state = novo_estado
		state_start = true

func _on_alien_death_finished() -> void:
	queue_free()
	
func _on_bullet_timer_timeout() -> void:
	can_shoot = true
	print("lucas é um corno")

func on_switch_to_shoot() -> void:
	if death:
		set_state(DEATH)
	elif retreat:
		set_state(RETREAT)
	else:
		set_state(SHOOT)

func on_switch_to_chase() -> void:
	if death:
		set_state(DEATH)
	elif retreat: 
		set_state(RETREAT)
	else: 
		set_state(CHASE)
