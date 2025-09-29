extends BaseEnemy
@export var patrol_points: Array[Node3D] = []
@onready var detect = $detect
var patrol_index = 0

@onready var delay = $Delay
@onready var chase_timer: Timer = $"Chase Timer"
var boss_name = "FORGETFULNESS"
var patrol_finished = false
var update_path_timer = 0.5
var can_chase = false
var chase_delay = 3
func _ready(): 
	Globals.max_contador += 1
	Globals.contador += 1
	Globals.slowdown.connect(on_slowdown)
	Globals.score_value = 3000
	SPEED += 2
	vida += 5000
	randomize_patrol()
func _physics_process(delta: float) -> void:
	if detect.get_overlapping_bodies().has(player):
		if Globals.is_audio_playing:
			lerp(velocity.x, 0.0, 0.2)
			lerp(velocity.z, 0.0, 0.2)
			switch_to_chase()
		else:
			chase_delay -= delta
			if chase_delay <= 0:
				can_chase = false
				set_state(IDLE)
				chase_delay = 3
	match current_state:
		IDLE:
			idle_state(delta)
		CHASE:
			chase_state(delta)
		ATTACK:
			attack_state(delta)
		DEATH:
			death_state(delta)

	var distance_threshold = 2.0
	if global_position.distance_to(patrol_points[patrol_index].global_position) < distance_threshold:
		#print("Boss is near the patrol marker!")
		patrol_finished = true

func idle_state(delta):
	if death:
		set_state(DEATH)
	if patrol_finished:
		lerp(velocity.x, 0.0, 0.2)
		lerp(velocity.z, 0.0, 0.2)
		update_path_timer -= delta
		if update_path_timer <= 0:
			patrol_finished = false
			randomize_patrol()
			update_path_timer = 0.5
	nav_agent.set_target_position(patrol_points[patrol_index].global_transform.origin)
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * (SPEED - 2)
	velocity = new_velocity
	var current_facing = -global_transform.basis.z
	var new_dir = current_facing.slerp(velocity,0.04).normalized()
	look_at(global_transform.origin + new_dir, Vector3.UP)
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
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * (SPEED + 2)
	velocity = new_velocity
	var current_facing = -global_transform.basis.z
	var new_dir = current_facing.slerp(velocity,0.07).normalized()
	look_at(player.global_transform.origin + new_dir, Vector3.UP)
	rotation.x = 0
	move_and_slide()

func randomize_patrol():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	patrol_index = rng.randi_range(0,9)
func _on_hit_body_entered(body: Node3D) -> void:
	if body.name == "player":
		body.HP -= 35
		body.add_screen_shake(1)

func _on_close_detect_body_entered(body: Node3D) -> void:
	if body.name == "player":
		switch_to_chase()

func _on_close_detect_body_exited(body: Node3D) -> void:
	if body.name == "player":
		lerp(velocity.x, 0.0, 0.2)
		lerp(velocity.z, 0.0, 0.2)
		await get_tree().create_timer(2).timeout
		set_state(IDLE)
