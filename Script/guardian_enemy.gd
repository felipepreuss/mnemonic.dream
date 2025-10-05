extends BaseEnemy
var enemy_guardian_material = load("res://Scenes/guardian_enemy.tscn::StandardMaterial3D_c4i4k")
func _ready():
	Globals.max_contador += 1
	Globals.contador += 1
	score_value = 170
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
	if Globals.contador <= 2 or Globals.boss_killed:
		print(Globals.contador)
		if enemy_guardian_material != null:
			enemy_guardian_material.set_stencil_mode(2)
			enemy_guardian_material.stencil_color = Color(255,255,0)

func _on_attack_box_body_entered(body: Node3D) -> void:
	if !retreat:
		if body.name == "player":
				body.HP -= 20
				body.add_screen_shake(0.6)
