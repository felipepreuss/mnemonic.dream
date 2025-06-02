extends CharacterBody3D
@onready var crosshair = $UI/Crosshair
@onready var Head =  $head
@onready var Camera =  $head/Camera3D
@onready var walking = $AudioStreamPlayer3D
#@onready var vida = $head/HUD/Color/Vbox/Vida
#@onready var weapon = $head/Camera3D/weapon
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ACELERATION = 2.2
# Weapon related vars
#var bala = preload("res://Scenes/bala.tscn")
#@onready var animation_player = $head/Camera3D/weapon/AnimationPlayer
const SENSITIVITY = 0.003

var life_value = 200



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
	 

	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backwards")
	var direction = (Head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		walking.play()
	move_and_slide()
	#atirar
	#if Input.is_action_just_pressed("Left-Click") and Globals.have_ammo:
		#animation_player.play("shoot")
		#if ray.is_colliding():
			#var target = ray.get_collider()
			#if target.is_in_group("Enemy"):
				##var dano = randi_range(0,3)
				##target.calcularDano(dano)
		#Globals.current_ammo -= 1
	#if Globals.current_ammo <= 0:
		#Globals.have_ammo = false
	#if Globals.ammo > 0:
		#Globals.can_reload = true
	#if Globals.ammo <= 0:
		#Globals.can_reload = false
	
