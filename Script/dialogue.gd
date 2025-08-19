extends Control
@onready var ui = $Ui
@onready var nome = $Ui/PanelContainer/VBoxContainer/Label
@onready var texto= $Ui/PanelContainer/VBoxContainer/Labelo

var dialogo: Dialogo:
	set(value):
		dialogo = value
		nome.text = value.personagem
		texto.text = value.texto

func _ready():
	dialogo = load('res://Script/Dialogos/0.tres')

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and ui.visible == true:
		if dialogo.next_dialog != null:
			dialogo = dialogo.next_dialog
		else:
			ui.visible = false
