extends BaseEnemy
class_name SpiderEnemy
var max_speed = 15
var run_speed = 5
var min_speed = 4
@onready var AttackBox = $attack_box
var can_hit = false
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
	if run_speed > max_speed:
		run_speed = max_speed
	elif run_speed < min_speed:
		run_speed = min_speed
	else:
		run_speed -= 0.5
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
	pass

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


func _on_bullet_timer_timeout() -> void:
	pass

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
