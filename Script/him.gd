extends BaseEnemy
class_name HimEnemy
# E LEBRON JAMES COLOCOU NENHUMA EXPLICAÇÃO NISSO

var alien = preload("res://Scenes/enemy.tscn")
var goblin = preload("res://Scenes/goblin_enemy.tscn")
var vai = false
var boss_name = "Parent"
func _ready():
	vida += 2800
	SPEED -= 2.0
	Globals.max_contador += 1
	Globals.contador += 1
	score_value = 33663
	Globals.slowdown.connect(on_slowdown)
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

func idle_state(delta):
	if death:
		set_state(DEATH)
	elif CHASE:
		set_state(ATTACK)
	elif retreat:
		set_state(RETREAT)
	look_at(player.global_transform.origin, Vector3.UP)
func chase_state(delta):
	if death:
		set_state(DEATH)
	elif attack:
		set_state(ATTACK)
	elif retreat:
		set_state(RETREAT)
	elif angry:
		set_state(ANGRY)
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = new_velocity
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	move_and_slide()

func attack_state(delta):
	look_at(player.global_transform.origin, Vector3.UP)


func calcularDano(dano:int):
	#otimizado? não, funciona? sim, não reclama meu amigo
	vida -= dano
	print(vida)
	if SPEED <= 7.0:
		SPEED += 0.2
	$alienHurt.play()
	if vida <= 0:
		death = true
	elif vida <= 2000:
		if vai == true:
			print (vai)
			vai = false
			var enemy_instance = alien.instantiate()
			enemy_instance.player = self.player
			get_parent().add_child(enemy_instance)
			enemy_instance.global_position = global_position
			if vida <= 1000:
				var goblin_instance = goblin.instantiate()
				goblin_instance.player = self.player
				get_parent().add_child(goblin_instance)
				goblin_instance.global_position = global_position


func death_state(delta):
	emit_signal("on_death")
	$alienDeath.play()

func _on_attack_box_body_entered(body: Node3D) -> void:
	if body.name == "player":
			body.HP -= 4
			body.add_screen_shake(0.9)

func _on_alien_death_finished() -> void:
		Globals.contador -= 1
		print("inimigos",Globals.contador)
		Globals.score += score_value
		print("score",Globals.score)
		Globals.boss_killed = true
		queue_free()

func _on_calma_timeout() -> void:
	vai = true
	print("vai")
