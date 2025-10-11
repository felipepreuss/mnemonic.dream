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
			reset_outlines()
			reset_shader()
			$"1/icon".material.set_shader_parameter("outline_color",Color(0,0,0))
			$"1/icon".material.set_shader_parameter("outline_width",5)
			$"1/Label".add_theme_constant_override("outline_size",10)
		2:
			reset_outlines()
			reset_shader()
			$"2/icon".material.set_shader_parameter("outline_color",Color(0,0,0))
			$"2/icon".material.set_shader_parameter("outline_width",5)
			$"2/Label".add_theme_constant_override("outline_size",10)
		3:
			reset_outlines()
			reset_shader()
			$"3/icon".material.set_shader_parameter("outline_color",Color(0,0,0))
			$"3/icon".material.set_shader_parameter("outline_width",5)
			$"3/Label".add_theme_constant_override("outline_size",10)
		4:
			reset_outlines()
			reset_shader()
			$"4/icon".material.set_shader_parameter("outline_color",Color(0,0,0))
			$"4/icon".material.set_shader_parameter("outline_width",5)
			$"4/Label".add_theme_constant_override("outline_size",10)
		5:
			reset_outlines()
			reset_shader()
			$"5/icon".material.set_shader_parameter("outline_color",Color(0,0,0))
			$"5/icon".material.set_shader_parameter("outline_width",5)
			$"5/Label".add_theme_constant_override("outline_size",10)
		6:
			reset_outlines()
			reset_shader()
			$"6/icon".material.set_shader_parameter("outline_color",Color(0,0,0))
			$"6/icon".material.set_shader_parameter("outline_width",5)
			$"6/Label".add_theme_constant_override("outline_size",10)
func reset_outlines():
	$"1/Label".add_theme_constant_override("outline_size",-10)
	$"2/Label".add_theme_constant_override("outline_size",-10)
	$"3/Label".add_theme_constant_override("outline_size",-10)
	$"4/Label".add_theme_constant_override("outline_size",-10)
	$"5/Label".add_theme_constant_override("outline_size",-10)
	$"6/Label".add_theme_constant_override("outline_size",-10)
	
func reset_shader():
	$"1/icon".material.set_shader_parameter("outline_color",Color(1,1,1))
	$"1/icon".material.set_shader_parameter("outline_width",5)
	$"2/icon".material.set_shader_parameter("outline_color",Color(1,1,1))
	$"2/icon".material.set_shader_parameter("outline_width",5)
	$"3/icon".material.set_shader_parameter("outline_color",Color(1,1,1))
	$"3/icon".material.set_shader_parameter("outline_width",5)
	$"4/icon".material.set_shader_parameter("outline_color",Color(1,1,1))
	$"4/icon".material.set_shader_parameter("outline_width",5)
	$"5/icon".material.set_shader_parameter("outline_color",Color(1,1,1))
	$"5/icon".material.set_shader_parameter("outline_width",5)
	$"6/icon".material.set_shader_parameter("outline_color",Color(1,1,1))
	$"6/icon".material.set_shader_parameter("outline_width",5)
