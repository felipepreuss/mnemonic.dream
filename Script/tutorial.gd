extends Node3D
@onready var player = $SubViewportContainer/SubViewport/player
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	get_tree().call_group("Enemy","update_target_location", player.global_transform.origin)

func _ready():
	Dialogue.dialogo = load('res://Script/Dialogos/0.tres')
	Globals.is_tutorial = true
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player" and Globals.contador <= 0:
		body.reset_powerups()
		get_tree().change_scene_to_file.call_deferred("res://Scenes/level_complete.tscn")
