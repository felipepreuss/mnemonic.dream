extends Control

@onready var weapons_manager: WeaponsManager = $"../../Camera3D/WeaponsManager"
var selected_weapon: int

func _physics_process(delta: float) -> void:
	var gun_list = weapons_manager.weapon_scenes
	var gun_list_size = gun_list.size()
	match gun_list_size:
		2:
			$"2".visible = true
		3:
			$"2".visible = true
			$"3".visible = true
		4:
			$"2".visible = true
			$"3".visible = true
			$"4".visible = true
		5:
			$"2".visible = true
			$"3".visible = true
			$"4".visible = true
			$"5".visible = true
		6:
			$"2".visible = true
			$"3".visible = true
			$"4".visible = true
			$"5".visible = true
			$"6".visible = true
	if weapons_manager.current_gun.gun_name == "Bat":
		selected_weapon = 1
		#$"1".color = Color(1,1,1,0.2)
	if weapons_manager.current_gun.gun_name == "Pistol":
		selected_weapon = 2
		#$"2".color = Color(1,1,1,0.2)
	if weapons_manager.current_gun.gun_name == "Shotgun":
		selected_weapon = 3
		#$"3".color = Color(1,1,1,0.2)
	if weapons_manager.current_gun.gun_name == "SMG":
		selected_weapon = 4
		#$"4".color = Color(1,1,1,0.2)
	if weapons_manager.current_gun.gun_name == "Dart Rifle":
		selected_weapon = 5
		#$"5".color = Color(1,1,1,0.2)
	if weapons_manager.current_gun.gun_name == "Rocket Launcher":
		selected_weapon = 6
		#$"6".color = Color(1,1,1,0.2)
	match selected_weapon:
		1:
			$"1".color = Color(1,1,1,0.2)
			$"2".color = Color(1,1,1,0.03)
			$"3".color = Color(1,1,1,0.03)
			$"4".color = Color(1,1,1,0.03)
			$"5".color = Color(1,1,1,0.03)
			$"6".color = Color(1,1,1,0.03)
		2:
			$"1".color = Color(1,1,1,0.03)
			$"2".color = Color(1,1,1,0.2)
			$"3".color = Color(1,1,1,0.03)
			$"4".color = Color(1,1,1,0.03)
			$"5".color = Color(1,1,1,0.03)
			$"6".color = Color(1,1,1,0.03)
		3:
			$"1".color = Color(1,1,1,0.03)
			$"2".color = Color(1,1,1,0.03)
			$"3".color = Color(1,1,1,0.2)
			$"4".color = Color(1,1,1,0.03)
			$"5".color = Color(1,1,1,0.03)
			$"6".color = Color(1,1,1,0.03)
		4:
			$"1".color = Color(1,1,1,0.03)
			$"2".color = Color(1,1,1,0.03)
			$"3".color = Color(1,1,1,0.03)
			$"4".color = Color(1,1,1,0.2)
			$"5".color = Color(1,1,1,0.03)
			$"6".color = Color(1,1,1,0.03)
		5:
			$"1".color = Color(1,1,1,0.03)
			$"2".color = Color(1,1,1,0.03)
			$"3".color = Color(1,1,1,0.03)
			$"4".color = Color(1,1,1,0.03)
			$"5".color = Color(1,1,1,0.2)
			$"6".color = Color(1,1,1,0.03)
		6:
			$"1".color = Color(1,1,1,0.03)
			$"2".color = Color(1,1,1,0.03)
			$"3".color = Color(1,1,1,0.03)
			$"4".color = Color(1,1,1,0.03)
			$"5".color = Color(1,1,1,0.03)
			$"6".color = Color(1,1,1,0.2)
