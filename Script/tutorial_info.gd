extends Control
@onready var ui = $Ui
@onready var texto= $Ui/PanelContainer/VBoxContainer/Labelo

var dialogo: Dialogo:
	set(value):
		Globals.dialogue_start = true
		dialogo = value
		texto.text = value.texto
		

func _ready():
	dialogo = load('res://Script/Dialogos/Info.tres')

func _process(delta):
	if Input.is_action_just_pressed("Left-Click") and ui.visible == true:
		if dialogo.next_dialog != null:
			dialogo = dialogo.next_dialog
			Globals.dialogue_end = false
			Globals.dialogue_start = true
		else:
			ui.visible = false
			Globals.dialogue_end = true
			Globals.dialogue_start = false
