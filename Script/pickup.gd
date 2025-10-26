extends Area3D

@export var new_gun: PackedScene 
@onready var animation_gun = $AnimationPlayer
@export var enemy: CharacterBody3D
var orphan = false
var can_get_gun = false

# new variable — the GLB visual path
var gun_visual_path: String

func _ready() -> void:
	if enemy != null:
		enemy.on_death.connect(_on_enemy_on_death)
	else:
		orphan = true

	animation_gun.play("rotaaate")

	# Select correct gun scene + model
	match Globals.current_level:
		0:
			new_gun = load("res://Scenes/pistol.tscn")
			gun_visual_path = "res://Assets/Guns/Pistola (1).glb"
		2:
			new_gun = load("res://Scenes/shot_gun.tscn")
			gun_visual_path = "res://Assets/Guns/Shotgun (1).glb"
		3:
			new_gun = load("res://Scenes/smg.tscn")
			gun_visual_path = "res://Assets/Guns/Metralhadora (1).glb"
		4:
			new_gun = load("res://Scenes/dart_rifle.tscn")
			gun_visual_path = "res://Assets/Guns/Shotgun (1).glb"
		5:
			new_gun = load("res://Scenes/rocket_launcher.tscn")
			gun_visual_path = "res://Assets/Guns/lancamissil.glb"

	if !Globals.is_tutorial and orphan:
		_spawn_visual_model()
		can_get_gun = true


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and can_get_gun:
		print("foi")
		var weapons_manager = body.find_child("WeaponsManager")
		
		if weapons_manager:
			weapons_manager.get_new_weapon(new_gun)
			queue_free()
		else:
			print("WeaponsManager n foi")


func _on_enemy_on_death():
	orphan = true
	if Globals.is_tutorial:
		_spawn_visual_model()
		orphan = false
		can_get_gun = true


# ------------------------------------------------------------
# This now loads the .glb directly and spawns it
# ------------------------------------------------------------
func _spawn_visual_model():
	if gun_visual_path == "":
		print("No visual path set for this weapon.")
		return

	var visual_scene = load(gun_visual_path)
	if visual_scene == null:
		print("Failed to load gun model:", gun_visual_path)
		return

	var visual_instance = visual_scene.instantiate()
	add_child(visual_instance)

	# Optional adjustments (position/scale)
	visual_instance.transform = Transform3D.IDENTITY
	visual_instance.scale = Vector3(1, 1, 1)
	visual_instance.rotation_degrees = Vector3(0, 0, 0)
