extends Label

@export var manager : WeaponsManager

func _physics_process(delta: float) -> void:
	#coloco qual arma especifica depois 
	#de entender o codigo do felipe 
	if manager.gun_equipped and manager is WeaponsManager:
		var nome = manager.weapon_scenes
		text = str(manager.current_gun.gun_name)
