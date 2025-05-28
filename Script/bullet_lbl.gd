extends Label
@export var manager : WeaponsManager

func _physics_process(delta: float) -> void:
	print(manager.current_gun)
	if manager.gun_equipped and manager is WeaponsManager:
		var nome = manager.current_gun
		text = str(nome.current_ammo)+"/"+str(nome.ammo)
