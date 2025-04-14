extends Label
@export var manager : WeaponsManager

func _physics_process(delta: float) -> void:
	print(manager.current_gun)
	if manager.gun_equipped and manager.get_child(1) is WeaponsManager:
		var nome = manager.get_child(1)
		text = str(nome.current_ammo)+"/"+str(nome.ammo)
