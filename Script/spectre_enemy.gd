extends AlienEnemy
var bullet1 = preload("res://Scenes/enemy_projectile.tscn")
var bullet2 = preload("res://Scenes/enemy_projectile.tscn")
var bullet3 = preload("res://Scenes/enemy_projectile.tscn")
var bullet4 = preload("res://Scenes/enemy_projectile.tscn")
var bullet5 = preload("res://Scenes/enemy_projectile.tscn")

# Enhanced stealth behavior variables
var is_visible = false  # Start invisible for more ominous approach
var min_distance = 8.0  # Minimum distance to maintain from player
var max_distance = 15.0 # Maximum distance before closing in
var invisibility_duration = 3.0  # Longer invisibility period
var visibility_duration = 1.5    # Shorter visibility window
var fire_rate = 2.5     # Slower fire rate (seconds between shots)
var last_fire_time = 0.0
var movement_speed_multiplier = 0.7  # Slower, more deliberate movement

# Gravity variables
var gravity = 20.0
var is_on_floor = false

func _ready():
	Globals.max_contador += 1
	Globals.contador += 1
	score_value = 300
	Globals.slowdown.connect(on_slowdown)
	
func idle_state(delta):
	if death:
		set_state(DEATH)
	elif Globals.dialogue_end:
		set_state(SHOOT)
	
	# Apply gravity
	_apply_gravity(delta)
	
	var current_location = global_transform.origin
	var new_velocity = (current_location).normalized() 
	velocity = Vector3(0, velocity.y, 0)  # Keep Y velocity for gravity
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	move_and_slide()

func chase_state(delta):
	if death:
		set_state(DEATH)
	elif retreat:
		set_state(RETREAT)
	elif attack:
		set_state(ATTACK)
	elif Globals.dialogue_start:
		set_state(IDLE)
	
	# Apply gravity first
	_apply_gravity(delta)
	
	var current_location = global_transform.origin
	var player_location = player.global_transform.origin
	var distance_to_player = current_location.distance_to(player_location)
	
	# Maintain distance from player - don't get too close
	if distance_to_player < min_distance:
		# Move away from player (horizontal only)
		var direction_away = (current_location - player_location).normalized()
		direction_away.y = 0  # Keep movement horizontal
		velocity.x = direction_away.x * SPEED * movement_speed_multiplier
		velocity.z = direction_away.z * SPEED * movement_speed_multiplier
	elif distance_to_player > max_distance:
		# Move toward player but maintain slower, more deliberate movement
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED * movement_speed_multiplier
		new_velocity.y = velocity.y  # Preserve gravity velocity
		velocity = new_velocity
	else:
		# Circle around player at optimal distance
		_circle_around_player(delta, false)
	
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	move_and_slide()

func _circle_around_player(delta, move_away: bool):
	var player_pos = player.global_transform.origin
	var current_pos = global_transform.origin
	
	# Calculate desired position around player at optimal distance
	var optimal_distance = (min_distance + max_distance) / 2
	var angle = atan2(current_pos.z - player_pos.z, current_pos.x - player_pos.x)
	angle += delta * 0.5  # Slow circling speed
	
	var desired_position = player_pos + Vector3(
		cos(angle) * optimal_distance,
		current_pos.y,  # Keep current Y position to prevent floating
		sin(angle) * optimal_distance
	)
	
	var direction = (desired_position - current_pos).normalized()
	direction.y = 0  # Only move horizontally
	velocity.x = direction.x * SPEED * movement_speed_multiplier
	velocity.z = direction.z * SPEED * movement_speed_multiplier

func _apply_gravity(delta):
	# Apply gravity if not on floor
	if not is_on_floor:
		velocity.y -= gravity * delta
	else:
		velocity.y = 0  # Reset vertical velocity when on floor

func shoot_state(delta):
	if death:
		set_state(DEATH)
	elif retreat:
		set_state(RETREAT)
	elif Globals.dialogue_start:
		set_state(IDLE)
	
	# Apply gravity
	_apply_gravity(delta)
	
	# Maintain distance even while shooting
	var current_location = global_transform.origin
	var player_location = player.global_transform.origin
	var distance_to_player = current_location.distance_to(player_location)
	
	# Move toward/away from player even while in shoot state
	if distance_to_player < min_distance:
		var direction_away = (current_location - player_location).normalized()
		direction_away.y = 0
		velocity.x = direction_away.x * SPEED * movement_speed_multiplier
		velocity.z = direction_away.z * SPEED * movement_speed_multiplier
	elif distance_to_player > max_distance:
		var direction_toward = (player_location - current_location).normalized()
		direction_toward.y = 0
		velocity.x = direction_toward.x * SPEED * movement_speed_multiplier * 0.5  # Slower approach
		velocity.z = direction_toward.z * SPEED * movement_speed_multiplier * 0.5
	else:
		# Minimal movement while shooting
		velocity.x = 0
		velocity.z = 0
	
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	rotation.z = 0
	
	# Slower firing rate implementation
	var current_time = Time.get_unix_time_from_system()
	if can_shoot == true and current_time - last_fire_time >= fire_rate:
		# Shoot all bullets
		var bala1 = bullet1.instantiate()
		get_parent().get_parent().get_parent().add_child(bala1)
		bala1.rotation.y = rotation.y
		bala1.global_position = $bullet_marker.global_position
		bala1.dir = transform.basis
		bala1.dir.x = -transform.basis.x
		
		var bala2 = bullet2.instantiate()
		get_parent().get_parent().get_parent().add_child(bala2)
		bala2.rotation.y = rotation.y
		bala2.global_position = $bullet_marker2.global_position
		bala2.dir = transform.basis
		bala2.dir.x = -transform.basis.x
		
		var bala3 = bullet3.instantiate()
		get_parent().get_parent().get_parent().add_child(bala3)
		bala3.rotation.y = rotation.y
		bala3.global_position = $bullet_marker3.global_position
		bala3.dir = transform.basis
		bala3.dir.x = -transform.basis.x
		
		var bala4 = bullet4.instantiate()
		get_parent().get_parent().get_parent().add_child(bala4)
		bala4.rotation.y = rotation.y
		bala4.global_position = $bullet_marker4.global_position
		bala4.dir = transform.basis
		bala4.dir.x = -transform.basis.x
		
		var bala5 = bullet5.instantiate()
		get_parent().get_parent().get_parent().add_child(bala5)
		bala5.rotation.y = rotation.y
		bala5.global_position = $bullet_marker5.global_position
		bala5.dir = transform.basis
		bala5.dir.x = -transform.basis.x
		
		last_fire_time = current_time
		can_shoot = false
		
		# Start the enhanced stealth attack cycle
		_start_stealth_attack_cycle()
	
	move_and_slide()

func _start_stealth_attack_cycle():
	# Longer invisibility period for more ominous behavior
	await get_tree().create_timer(0.5).timeout  # Brief delay after shooting
	visible = false
	is_visible = false
	
	# Stay invisible for extended period
	await get_tree().create_timer(invisibility_duration).timeout
	
	# Brief visibility window
	visible = true
	is_visible = true
	
	# Short visible period before disappearing again
	await get_tree().create_timer(visibility_duration).timeout
	
	# Reset shooting capability
	can_shoot = true
	
	# CHASE STATE ADDED HERE - Go back to chasing instead of shooting immediately
	if not death and not retreat and not Globals.dialogue_start:
		set_state(CHASE)  # Changed from SHOOT to CHASE

func _on_alien_death_finished() -> void:
	Globals.contador -= 1
	print("inimigos", Globals.contador)
	Globals.score += score_value
	print("score",Globals.score)
	queue_free()
