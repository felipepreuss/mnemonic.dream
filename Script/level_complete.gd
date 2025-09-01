extends Control

@onready var level_label: Label = $Label
@onready var kills: Label = $VBoxContainer/kills
@onready var v_box_container: VBoxContainer = $VBoxContainer

var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_label.text = "Level " + str(Globals.current_level + 1) + "\nCompleted"
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	kills.text = "Kills: " + str(Globals.max_contador - Globals.contador)
	
	level_label.visible_ratio = 0
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(level_label, "visible_ratio", 1, 2)
	
	await get_tree().create_timer(2).timeout
	for label in v_box_container.get_children():
		label.visible_ratio = 0
		tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(label, "visible_ratio", 1, 0.75)
	
	await get_tree().create_timer(0.8).timeout
	$HBoxContainer/next_button.visible = true
	$HBoxContainer/save_button.visible = true
func next_level():
	if Globals.current_level < Globals.levels.size():
		get_tree().change_scene_to_file(Globals.levels[Globals.current_level])
		Globals.current_level += 1
		print(Globals.current_level)
	else:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		
func _on_next_button_pressed() -> void:
	next_level()
