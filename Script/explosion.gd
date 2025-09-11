extends Node3D

@export var explosion_force = 8.5
@export var max_explosion_dist = 3.5
@export var explosion_damage = 10
@onready var hitbox = $Area3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GPUParticles3D.emitting = true

	await get_tree().physics_frame
	await get_tree().physics_frame
	push_away_bodies()
	
	var timer := get_tree().create_timer(5.0)
	timer.timeout.connect(func(): self.queue_free())

func _physics_process(delta: float) -> void:
	for enemies in hitbox.get_overlapping_bodies():
		if enemies.has_method("calcularDano"):
			enemies.calcularDano(80)
			print(enemies.vida)
func push_away_bodies():
	for body in $Area3D.get_overlapping_bodies():
		var body_pos = body.global_position
		var force_div = 1.0
		if body is CharacterBody3D:
			body_pos.y += 1.0
			force_div = 4.0 # Character bodies have no mass
		elif body is RigidBody3D:
			force_div = max(0.01, body.mass)
		var force_dir = self.global_position.direction_to(body_pos)
		var body_dist = (body_pos - self.global_position).length()
		var explosion_vec = lerp(0.0, explosion_force, 1.0 - clampf((body_dist / max_explosion_dist), 0.0, 1.0)) / force_div * force_dir
		#if body is RigidBody3D:
			#body.apply_impulse(explosion_vec * explosion_force)
		#elif body is CharacterBody3D:
			#body.velocity += explosion_vec * explosion_force
		#
	 
