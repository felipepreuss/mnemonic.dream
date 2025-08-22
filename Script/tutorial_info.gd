extends Control
		
func _ready():
	$Ui.visible = true
	

func _process(delta):
	if Input.is_action_just_pressed("Left-Click") and $Ui.visible == true:
		$Ui.visible = false
		get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
		
		

			
