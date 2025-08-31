extends CanvasLayer

func _ready():
	visible = false
func _process(_delta):
	if Input.is_action_just_pressed("Esc") && !visible:
		visible = true
		get_tree().paused = true
		
	elif Input.is_action_just_pressed("Esc") && visible:
		visible = false
		get_tree().paused = false
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _on_resume_pressed():
	get_tree().paused = false
	visible = false

func _on_options_pressed():
	pass

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn") 
	


func _on_save_pressed() -> void:
	pass
