extends Node3D
var acquire_weapon_scene = preload("res://Scenes/acquire_weapon.tscn")
@onready var enemy = $".."

var orphan = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy.on_death.connect(_on_enemy_on_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if orphan:
		var acquire_weapon = acquire_weapon_scene.instantiate()
		get_parent().add_child(acquire_weapon)
		acquire_weapon.position = self.position
		queue_free()
		if Globals.get_gun:
			queue_free()
	else:
		pass 
func _on_enemy_on_death() -> void:
	reparent(get_parent().get_parent())
	orphan = true
