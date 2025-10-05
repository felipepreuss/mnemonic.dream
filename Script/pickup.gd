extends Area3D

@export var new_gun: PackedScene 
@onready var animation_gun = $AnimationPlayer
@export var enemy: CharacterBody3D
var orphan = false
var can_get_gun = false

func _ready() -> void:
	if enemy != null:
		enemy.on_death.connect(_on_enemy_on_death)
	elif enemy == null:
		orphan = true
	animation_gun.play("rotaaate")
	# instancia a arma na cena
	if Globals.current_level == 0:
		new_gun = load("res://Scenes/pistol.tscn")
	if Globals.current_level == 2:
		new_gun = load("res://Scenes/shot_gun.tscn")
	if Globals.current_level == 3:
		new_gun = load("res://Scenes/smg.tscn")
	if Globals.current_level == 4:
		new_gun = load("res://Scenes/dart_rifle.tscn")
	if Globals.current_level == 5:
		new_gun = load("res://Scenes/rocket_launcher.tscn")
	if !Globals.is_tutorial and orphan:
		if new_gun != null:
				var gun_visual = new_gun.instantiate()
				gun_visual.set_process_mode(Node.PROCESS_MODE_DISABLED)
				add_child(gun_visual)
				can_get_gun = true
func _process(delta: float) -> void:
	pass
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and can_get_gun == true:
		print("foi")
		var weapons_manager = body.find_child("WeaponsManager")
		
		if weapons_manager:
			weapons_manager.get_new_weapon(new_gun)
			#adiciona ao player
			queue_free()
		else:
			print("WeaponsManager n foi")

func _on_enemy_on_death():
	orphan = true
	if Globals.is_tutorial:
			if new_gun != null:
				var gun_visual = new_gun.instantiate()
				gun_visual.set_process_mode(Node.PROCESS_MODE_DISABLED)
				add_child(gun_visual)
				orphan = false
				can_get_gun = true
				
