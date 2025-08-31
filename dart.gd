extends Node3D

var SPEED = 20.0
var dir : Basis

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
#@onready var ray_cast_3d: RayCast3D = $RayCast3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0,0, -SPEED) * delta
	
