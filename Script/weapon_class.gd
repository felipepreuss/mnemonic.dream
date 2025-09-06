class_name WeaponsManager extends Node3D

@export var auto: bool
@export var have_ammo = true
@export var current_ammo: int
@export var ammo :int
@export var max_ammo: int
@export var can_reload := false
@export var ray: RayCast3D
@export var local: Marker3D
@export var number_balas: int
@export var gun_name: String
@export var melee = false
@export var weapon_scenes: Array[PackedScene]

var current_gun: Node3D = null
var gun_equipped: bool = false
var gun_count: int = 0
var gun_limit: int = 1

# Store all weapon instances
var weapon_instances: Array[Node3D] = []

# auto gun fire rate variables
var last_shot_time = 0.0
var smg_fire_rate = 0.1  # auto fire rate

@onready var flash: GPUParticles3D
@onready var kickb: AnimationPlayer

func _ready() -> void:
	await get_parent().ready
	kickb = $AnimationPlayer  
	flash = $GunPosition/muzzle
	
	# Pre-instantiate all weapons
	for weapon_scene in weapon_scenes:
		var weapon_instance = weapon_scene.instantiate()
		add_child(weapon_instance)
		weapon_instance.hide()
		weapon_instance.set_process(false)
		weapon_instance.set_physics_process(false)
		weapon_instances.append(weapon_instance)
	
	# Equip first weapon
	if weapon_instances.size() > 0:
		switch_weapon(0)

func _physics_process(delta: float) -> void: 
	handle_weapon_switch()
	if current_gun != null:  
		handle_shooting()
		handle_reload()
		update_ammo_display()
	
	if Globals.get_gun:
		if weapon_scenes.size() == 1:
			get_new_weapon(load("res://Scenes/pistol.tscn"))
		elif weapon_scenes.size() == 2:
			get_new_weapon(load("res://Scenes/shot_gun.tscn"))
		elif weapon_scenes.size() == 3:
			get_new_weapon(load("res://Scenes/dart_rifle.tscn"))
		elif weapon_scenes.size() == 4:
			get_new_weapon(load("res://Scenes/rocket_launcher.tscn"))

func handle_shooting():
	if not current_gun or not gun_equipped:
		return
	
	var current_time = Time.get_ticks_msec() / 1000.0  # Current time in seconds
	
	if current_gun.auto and Input.is_action_pressed("Left-Click") and not current_gun.melee:
		# SMG rapid fire - check fire rate
		if current_time - last_shot_time >= smg_fire_rate:
			try_shoot()
			last_shot_time = current_time
	elif Input.is_action_just_pressed('Left-Click') and not current_gun.melee:
		try_shoot()
		last_shot_time = current_time

func try_shoot():
	if current_gun.current_ammo >= current_gun.number_balas and flash:
		flash.emitting = true
		flash.restart()
		kickb.play('recoil')
		get_parent().add_shake(0.5)
		current_gun.current_ammo -= current_gun.number_balas
		current_gun.have_ammo = current_gun.current_ammo > 0
	else:
		current_gun.have_ammo = false
		print('Sem balas suficientes!')

func handle_weapon_switch():
	for i in range(weapon_instances.size()):
		if Input.is_physical_key_pressed(KEY_0 + i + 1):
			switch_weapon(i)
			break

func handle_reload():
	if Input.is_action_just_pressed('Reload') and gun_equipped and current_gun:
		if current_gun.current_ammo < current_gun.max_ammo and current_gun.ammo > 0:
			var to_reload = min(current_gun.max_ammo - current_gun.current_ammo, current_gun.ammo)
			current_gun.current_ammo += to_reload
			current_gun.ammo -= to_reload
			current_gun.have_ammo = current_gun.current_ammo > 0
			print('Recarregado ', to_reload, ' balas.')

func update_ammo_display():
	if current_gun:
		#print(str(current_gun.current_ammo, '/', current_gun.ammo))
		pass

func switch_weapon(index: int):
	if index < weapon_instances.size():
		# Hide current weapon instead of destroying it
		if current_gun:
			current_gun.hide()
			current_gun.set_process(false)
			current_gun.set_physics_process(false)
		# Show and activate new weapon
		current_gun = weapon_instances[index]
		current_gun.show()
		current_gun.set_process(true)
		current_gun.set_physics_process(true)
		gun_equipped = true

func shooting(mira: RayCast3D, dano: int):
	var target = mira.get_collider()
	if mira.get_collider() != null and target.is_in_group('Enemy'):
		target.calcularDano(dano)

func get_new_weapon(weapon_slot: PackedScene):
	# Add to weapon scenes array
	weapon_scenes.append(weapon_slot)
	
	# Instantiate the new weapon but keep it hidden and disabled
	var weapon_instance = weapon_slot.instantiate()
	add_child(weapon_instance)
	weapon_instance.hide()
	weapon_instance.set_process(false)
	weapon_instance.set_physics_process(false)
	weapon_instances.append(weapon_instance)
