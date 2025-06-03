extends CharacterBody3D
@export var player : CharacterBody3D
var vida = 200
var SPEED = 3.0
var accel = 10
#maquina de estado
var retreat = false
var death = false
var attack = false


@onready var nav_agent = $NavigationAgent3D
enum {CHASE,ATTACK,RETREAT,DEATH}
var current_state = 0
var state_start = true

func _ready():
	pass

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
	print("retreating!")
	if death:
		set_state(DEATH)
		
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * (-SPEED)
	velocity = new_velocity
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	move_and_slide()
	
func death_state(delta):
	$alienDeath.play() 
	
func update_target_location(target_location):
	nav_agent.set_target_position(target_location)
	
func calcularDano(dano:int):
	vida -= dano
	print(vida)
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
	
