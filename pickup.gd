extends Area3D

@export var new_gun: PackedScene 
@onready var animation_gun = $AnimationPlayer

func _ready():
	animation_gun.play("rotaaate")
	# Just instantiate the gun scene to make it visible
	if new_gun != null:
		var gun_visual = new_gun.instantiate()
		add_child(gun_visual)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("foi")	
		var weapons_manager = body.find_child("WeaponsManager")
		
		if weapons_manager:
			weapons_manager.get_new_weapon(new_gun)
			queue_free()
		else:
			print("WeaponsManager n foi")
