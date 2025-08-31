extends RigidBody3D

@export var speed := 20.0
@export var life_time := 5.0

var timer := 0.0

func explode(pos: Vector3 = global_position, normal: Vector3 = Vector3.UP) -> void:
	var explosion_effect := preload("res://Scenes/explosion.tscn").instantiate()
	add_sibling(explosion_effect)
	explosion_effect.global_transform = Transform3D(Basis(Quaternion(Vector3.UP, normal)), position)
	self.queue_free()

func _process(delta: float) -> void:
	linear_velocity = -global_transform.basis.z * speed
	timer += delta
#	position += transform.basis * Vector3(0,0, -speed) * delta
	if timer >= life_time:
		explode()

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# Quando colidir com algo, explode
	if state.get_contact_count() > 0:
		var pos = state.get_contact_local_position(0)
		var normal = state.get_contact_local_normal(0)
		explode(pos, normal)
