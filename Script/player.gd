extends CharacterBody3D
@onready var crosshair = $UI/Crosshair
@onready var Head =  $head
@onready var Camera =  $head/Camera3D
@onready var walk_1: AudioStreamPlayer3D = $Walk1
@onready var walk_2: AudioStreamPlayer3D = $Walk2

#@onready var vida = $head/HUD/Color/Vbox/Vida
#@onready var weapon = $head/Camera3D/weapon
var SPEED = 5.0
var HP = 100
var max_HP = 125
var power_up = "none"
const JUMP_VELOCITY = 4.5
const ACELERATION = 2.2
# Weapon related vars
#var bala = preload("res://Scenes/bala.tscn")
#@onready var animation_player = $head/Camera3D/weapon/AnimationPlayer
const SENSITIVITY = 0.003

# use a var death caso alguem FODA a vida de novo
# (nao querendo mencionar ninguem LU- mrr mrr)
var death = false 

var chocolate_powerup = false
var delta_time = 0
var step_timer := 0.0
var step_interval := 0.5  # base interval between steps

signal healthChanged
signal switch_to_shoot
signal switch_to_chase


func _ready():
#	vida.value = life_value
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	crosshair.position.x = get_viewport().size.x /2 - 36 # Replace with function body.
	crosshair.position.y = get_viewport().size.y /2 - 36
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		Head.rotate_y(-event.relative.x * SENSITIVITY)
		Camera.rotate_x(-event.relative.y * SENSITIVITY)
		Camera.rotation.x = clamp(Camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	#if Dialogue != null and Dialogue.ui.visible:
		#get_tree().paused = true
	#else:
		#get_tree().paused = false
	delta_time += delta
	if delta_time >= 1.0:
		delta_time = 0
		if HP > 100:
			HP -= 1
	if Input.is_action_just_pressed("botão da morte mortal"):
		death = true
	if death or HP < 1:
		Globals.reset_powerups()
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		#Usar consumível
	if Input.is_action_just_pressed("Q"):
		powerup_check()
		powerup(power_up)
		power_up = "none"
		Globals.get_chiclete = false
		Globals.get_chocolate = false
		Globals.get_pop_candy = false
		
	var target_tilt = 0.0
	if Input.is_action_pressed("Right"):
		target_tilt = -0.05
	elif Input.is_action_pressed("Left"):
		target_tilt = 0.05
	Head.rotation.z = lerp(Head.rotation.z, target_tilt, 0.1)
 
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY *1.1
		$AudioStreamPlayer3D2.play()
	 
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backwards")
	var direction = (Head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction :
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if is_on_floor() and not walk_1.playing and not walk_2.playing:
					if randf() > 0.5:
						walk_1.play()
					else:
						walk_2.play()		
 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


	if Globals.pop_candy_powerup == true:
		SPEED = 10
	else:
		SPEED = 5
	move_and_slide()
	#atirar
	#if Input.is_action_just_pressed("Left-Click") and Globals.have_ammo:
		#animation_player.play("shoot")
		#if ray.is_colliding():
			#var target = ray.get_collider()
			#if target.is_in_group("Enemy"):
				#var dano = randi_range(0,3)
				#target.calcularDano(dano)
		#Globals.current_ammo -= 1
	#if Globals.current_ammo <= 0:
		#Globals.have_ammo = false
	#if Globals.ammo > 0:
		#Globals.can_reload = true
	#if Globals.ammo <= 0:
		#Globals.can_reload = false


func powerup(powerup):
	if powerup == "pop_candy":
		Globals.pop_candy_powerup = true
		await get_tree().create_timer(10).timeout
		Globals.pop_candy_powerup = false
	if powerup == "chiclete":
		Globals.chiclete_powerup = true
	if powerup == "chocolate":
		HP += 70
		if HP > max_HP:
			HP = 125
	else:
		pass

func powerup_check():
	if Globals.get_chiclete:
		power_up = "chiclete"
	elif Globals.get_pop_candy:
		power_up = "pop_candy"
	elif Globals.get_chocolate:
		power_up = "chocolate"

func reset_powerups():
	Globals.pop_candy_powerup = false
	Globals.chiclete_powerup = false
	HP = 100
func _on_enemy_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		body.switch_to_shoot()


func _on_enemy_box_body_exited(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		body.switch_to_chase()


func _on_player_box_area_entered(area: Area3D) -> void:
	if area.is_in_group("Bullet"):
		HP -= 5
		healthChanged.emit()
		print (HP)


func _on_weapon_get_area_body_entered(body: Node3D) -> void:
	pass
