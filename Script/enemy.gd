extends CharacterBody3D
@export var player : CharacterBody3D
var vida = 200
var SPEED = 3.0

var accel = 10

@onready var nav_agent = $NavigationAgent3D
#@onready var hurt = $alienHurt
#var LOW_DAMAGE = randf_range(1,20)
#var MEDIUM_DAMAGE = randf_range(21,50)
#var BIG_DAMAGE = randf_range(51,100)
#var CRITICAL_DAMAGE = randf_range(101,200)
enum {CHASE,RETREAT,DEATH}
var current_state = 0
var state_start = true

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match current_state:
		CHASE:
			chase_state(delta)
		RETREAT:
			retreat_state(delta)
		DEATH:
			death_state(delta)

func chase_state(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = new_velocity
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	move_and_slide()
	
func retreat_state(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = new_velocity
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	move_and_slide()
	
func death_state(delta):
	pass#queue_free()
	
func update_target_location(target_location):
	nav_agent.set_target_position(target_location)
	
func calcularDano(dano:int):
	vida -= dano
	$alienHurt.play()
	if vida <= 0:
		$alienDeath.play()
		
func set_state(novo_estado):
	if novo_estado != current_state:
		current_state = novo_estado
		state_start = true


func _on_alien_death_finished() -> void:
	queue_free() # Replace with function body.
