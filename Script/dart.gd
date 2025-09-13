extends Node3D

var SPEED = 20.0
var dir : Basis

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var poison_area_scene = preload("res://Scenes/poison_area.tscn")
#@onready var ray_cast_3d: RayCast3D = $RayCast3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0,0, -SPEED) * delta


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group('Enemy') or body is CSGCombiner3D:
		var poison_area = poison_area_scene.instantiate()
		get_parent().add_child(poison_area)
		poison_area.position = self.position
		if body.has_method("calcularDano"):
			body.calcularDano(25)
		queue_free()
