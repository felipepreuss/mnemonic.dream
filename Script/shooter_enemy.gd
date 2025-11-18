extends BaseEnemy
class_name ShooterEnemy

var can_shoot = false
@onready var aim = $RayCast3D
@onready var flash = $flash
@onready var gun_sound = $gun_fire

var enemy_shooter_material = load("res://Scenes/shooter_enemy.tscn::StandardMaterial3D_vuv4i")
func _ready():
	Globals.max_contador += 1
	Globals.contador += 1
	score_value = 230
	Globals.slowdown.connect(on_slowdown)
	$MeshInstance3D.play("idle")
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
		enemy_shooter_material.set_stencil_mode(2)
		enemy_shooter_material.stencil_color = Color(255,255,0)
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
	if can_shoot == true:
		randomize()
		var target = aim.get_collider()
		if aim.get_collider() != null and target.is_in_group('Player'):
			var accuracy = randi_range(0,10)
			print(accuracy)
			flash.emitting = true
			flash.restart()
			gun_sound.play()
			$MeshInstance3D.play('shoot')
			 
			
			if accuracy < 5:
				target.HP -= 10
		can_shoot = false
	move_and_slide()

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
