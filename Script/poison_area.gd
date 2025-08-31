extends Area3D
var can_hit = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for enemies in self.get_overlapping_bodies():
		if enemies.has_method("calcularDano") and can_hit:
			enemies.calcularDano(25)
			print(enemies.vida)
			can_hit = false

func _on_poison_timer_timeout() -> void:
	queue_free()

func _on_hit_timer_timeout() -> void:
	can_hit = true

func _on_body_entered(body: Node3D) -> void:
	pass
