extends AlienEnemy
class_name Clone


func _ready():
	Globals.max_contador += 1
	Globals.contador += 1
	Globals.slowdown.connect(on_slowdown)
	vida += 300
	score_value += 666
	SPEED += 12.0

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
