extends CharacterBody3D
class_name Player
@onready var crosshair = $UI/Crosshair
@onready var Head =  $head
@onready var Camera =  $head/Camera3D
@onready var interact_ray: RayCast3D = $head/Camera3D/interact_ray
@onready var walk_1: AudioStreamPlayer3D = $Walk1
@onready var walk_2: AudioStreamPlayer3D = $Walk2
@export var boss : CharacterBody3D

@onready var chocolate_tutorial: ColorRect = $head/HUD/chocolate_tutorial
@onready var pop_candy_tutorial: ColorRect = $head/HUD/pop_candy_tutorial
@onready var chiclete_tutorial: ColorRect = $head/HUD/chiclete_tutorial

signal boss_bar_visible
var can_spawn_boss = true
#@onready var vida = $head/HUD/Color/Vbox/Vida
#@onready var weapon = $head/Camera3D/weapon
var SPEED = 12.0
var HP = 100
var max_HP = 125
var power_up = "none"

# Movement variables
const JUMP_VELOCITY = 4.5
const ACCELERATION = 15.0
const AIR_ACCELERATION = 5.0
const FRICTION = 20.0
const AIR_FRICTION = 5.0

# Coyote time and jump buffering
var coyote_time = 0.0
const COYOTE_TIME_THRESHOLD = 0.15
var jump_buffer = 0.0
const JUMP_BUFFER_THRESHOLD = 0.1

# Dash variables
var is_dashing = false
var dash_direction = Vector3.ZERO
var dash_timer = 0.0
const DASH_DURATION = 0.15
const DASH_SPEED = 25.0
const DASH_COOLDOWN = 0.8
var dash_cooldown_timer = 0.0
var can_dash = true
var dash_trail_effect = null
var can_jump = true
# Camera effects
var target_fov = 75.0
const BASE_FOV = 75.0
const FOV_CHANGE = 5.0
const DASH_FOV_CHANGE = 10.0

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

# Get gravity from project settings
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	#	vida.value = life_value
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	crosshair.position.x = get_viewport().size.x / 2 - 36
	crosshair.position.y = get_viewport().size.y / 2 - 36
	
	# Reset jump variables to prevent automatic jumping
	reset_jump_variables()
	
	# Preload dash trail effect if you have one
	# dash_trail_effect = preload("res://Effects/DashTrail.tscn")
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		Head.rotate_y(-event.relative.x * SENSITIVITY)
		Camera.rotate_x(-event.relative.y * SENSITIVITY)
		Camera.rotation.x = clamp(Camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func pause_movement():
	SPEED = 0
	can_dash = false
	can_jump = false
func unpause_movement():
	can_jump = true
func interact():
	var npc = interact_ray.get_collider()
	if interact_ray.get_collider() != null and npc.is_in_group('NPC'):
		npc.dialogue()
		
func _physics_process(delta: float) -> void:
	if walk_1.playing:
		Globals.is_audio_playing = true
	if walk_2.playing:
		Globals.is_audio_playing = true
	# Handle dash cooldown
	if not can_dash:
		dash_cooldown_timer += delta
		if dash_cooldown_timer >= DASH_COOLDOWN:
			can_dash = true
			dash_cooldown_timer = 0.0
	# Handle coyote time and jump buffer
	coyote_time += delta
	jump_buffer += delta
	
	delta_time += delta
	if delta_time >= 1.0:
		delta_time = 0
		if HP > 100:
			HP -= 1
	if Input.is_action_just_pressed("botão da morte mortal"):
		death = true
	if Input.is_action_just_pressed("Interact"):
		interact()
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
	Head.rotation.z = lerp(Head.rotation.z, target_tilt, 0.3)
 
	# Handle dash input
	if Input.is_action_just_pressed("Shift") and can_dash and not is_dashing:
		start_dash()
	
	# Handle dash movement
	if is_dashing:
		handle_dash(delta)
		return  # Skip normal movement during dash
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0  # Reset vertical velocity when on floor
		coyote_time = 0.0  # Reset coyote time when on floor
	
	# Handle jump input
	if Input.is_action_just_pressed("Jump") and can_jump:
		jump_buffer = 0.0
	
	# Handle jump with coyote time and jump buffer
	# FIXED: Added additional check to ensure we're not automatically jumping on scene load
	if (jump_buffer < JUMP_BUFFER_THRESHOLD) and (coyote_time < COYOTE_TIME_THRESHOLD) and jump_buffer > 0:
		velocity.y = JUMP_VELOCITY
		$AudioStreamPlayer3D2.play()
		Globals.is_audio_playing = true
		coyote_time = COYOTE_TIME_THRESHOLD
		jump_buffer = JUMP_BUFFER_THRESHOLD
	 
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backwards")
	var direction = (Head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Apply movement with different ground/air physics
	if is_on_floor():
		if direction:
			velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
			velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
			
			# Play footstep sounds
			if not walk_1.playing and not walk_2.playing:
				if randf() > 0.5:
					walk_1.play()
				else:
					walk_2.play()
			# Increase FOV when moving for speed effect
			target_fov = BASE_FOV + FOV_CHANGE
		else:
			# Apply friction when not moving
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
			velocity.z = move_toward(velocity.z, 0, FRICTION * delta)
			target_fov = BASE_FOV
	else:
		# Air control
		if direction:
			velocity.x = move_toward(velocity.x, direction.x * SPEED, AIR_ACCELERATION * delta)
			velocity.z = move_toward(velocity.z, direction.z * SPEED, AIR_ACCELERATION * delta)
		else:
			# Less friction in air
			velocity.x = move_toward(velocity.x, 0, AIR_FRICTION * delta)
			velocity.z = move_toward(velocity.z, 0, AIR_FRICTION * delta)

	# Apply FOV change smoothly
	Camera.fov = lerp(Camera.fov, target_fov, 10 * delta)

	if Globals.pop_candy_powerup == true:
		SPEED = 15
	else:
		SPEED = 7
		
	move_and_slide()

func start_dash():
	is_dashing = true
	dash_timer = 0.0
	can_dash = false
	
	# Determine dash direction based on input
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backwards")
	if input_dir != Vector2.ZERO:
		# Dash in the direction of input
		dash_direction = (Head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	else:
		# Dash forward if no input
		dash_direction = -Head.global_transform.basis.z
	
	# Set velocity for dash
	velocity = dash_direction * DASH_SPEED
	velocity.y = 0  # Keep dash horizontal
	
	# Visual effects
	target_fov = BASE_FOV + DASH_FOV_CHANGE
	
	# Play dash sound if available
	# $DashSound.play()
	
	# Create dash trail effect if available
	# if dash_trail_effect:
	#     var trail = dash_trail_effect.instantiate()
	#     add_child(trail)

func handle_dash(delta):
	dash_timer += delta
	
	if dash_timer >= DASH_DURATION:
		# End dash
		is_dashing = false
		velocity = velocity * 0.5  # Slow down after dash
		target_fov = BASE_FOV
	else:
		# Maintain dash velocity
		velocity = dash_direction * DASH_SPEED
	
	move_and_slide()

# NEW FUNCTION: Reset jump variables to prevent automatic jumping
func reset_jump_variables():
	coyote_time = COYOTE_TIME_THRESHOLD  # Set to max to prevent immediate jump
	jump_buffer = JUMP_BUFFER_THRESHOLD  # Set to max to prevent immediate jump

# NEW: Called when the node enters the scene tree
func _enter_tree():
	reset_jump_variables()

# NEW: Called when the node is ready
func _notification(what):
	match what:
		NOTIFICATION_READY:
			# Small delay to ensure everything is properly initialized
			await get_tree().create_timer(0.1).timeout
			reset_jump_variables()

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
		if $head/HUD/chocolate_tutorial.visible == false and $head/HUD/pop_candy_tutorial.visible == false:
			chiclete_tutorial.visible = true
	elif Globals.get_pop_candy:
		power_up = "pop_candy"
		if $head/HUD/chocolate_tutorial.visible == false and $head/HUD/chiclete_tutorial.visible == false:
			pop_candy_tutorial.visible = true
	elif Globals.get_chocolate:
		power_up = "chocolate"
		if $head/HUD/chiclete_tutorial.visible == false and $head/HUD/pop_candy_tutorial.visible == false:
			chocolate_tutorial.visible = true
func reset_powerups():
	Globals.pop_candy_powerup = false
	Globals.chiclete_powerup = false
	HP = 100
	
func get_weapons():
	var weapons_manager = find_child("WeaponsManager")
	if weapons_manager:
		weapons_manager.weapon_check()

func _on_enemy_box_body_entered(body: Node3D) -> void:
	#if body.is_in_group("Enemy"):
		#if body.has_method("switch_to_shoot"):
			#body.switch_to_shoot()
	pass
func _on_enemy_box_body_exited(body: Node3D) -> void:
	#if body.is_in_group("Enemy"):
		#if body.has_method("switch_to_chase"):
			#body.switch_to_chase()
	pass
func _on_player_box_area_entered(area: Area3D) -> void:
	if area.is_in_group("Bullet"):
		HP -= 5
		healthChanged.emit()
		print(HP)

func _on_player_box_body_entered(body: Node3D) -> void:
	#if body.is_in_group("Enemy"):
		#if body.has_method("switch_to_attack"):
			#body.switch_to_attack()
	pass
func add_screen_shake(shake_amount) -> void:
	Camera.add_shake(shake_amount)


func _on_boss_spawn_body_entered(body: Node3D) -> void:
	if body.name == "player":
		if can_spawn_boss:
			var clone = load("res://Scenes/doppelganger.tscn")
			var boss_clone = clone.instantiate()
			boss_clone.player = self
			#boss_clone.transform.basis = transform.basis
			get_parent().add_child(boss_clone)
			boss_clone.rotation.y = rotation.y
			boss_clone.global_position = $"../../../boss_marker".global_position
			#boss_clone.dir = transform.basis
			#boss_clone.dir.x = -transform.basis.x
			boss = boss_clone
			can_spawn_boss = false


func _on_walk_1_finished() -> void:
	Globals.is_audio_playing = false


func _on_walk_2_finished() -> void:
	Globals.is_audio_playing = false


func _on_audio_stream_player_3d_2_finished() -> void:
	Globals.is_audio_playing = false


func _on_boss_area_body_entered(body: Node3D) -> void:
	if body.name == "player":
		emit_signal("boss_bar_visible")
		
