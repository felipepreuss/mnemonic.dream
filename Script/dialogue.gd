extends Control
@onready var ui = $Ui
@onready var nome = $Ui/PanelContainer/VBoxContainer/Label
@onready var texto = $Ui/PanelContainer/VBoxContainer/Labelo
var txt = ""

var dialogo: Dialogo:
	set(value):
		Globals.CabouTexto = false
		Globals.dialogue_start = true
		dialogo = value
		nome.text = value.personagem
		texto.text = value.texto
		txt = ""
		ui.visible = true
		for x in texto.text:
			await get_tree().create_timer(0.01).timeout
			txt += x
		Globals.CabouTexto = true
		
func _ready():
	Dialogue.ui.visible = false
	
func _process(delta):
	$Ui/PanelContainer/VBoxContainer/Labelo.text = txt
	if Input.is_action_just_pressed("Left-Click") and ui.visible and Globals.CabouTexto:
		if dialogo.next_dialog != null:
			Globals.CabouTexto = false
			await get_tree().create_timer(0.2).timeout
			dialogo = dialogo.next_dialog
			Globals.dialogue_end = false
			Globals.dialogue_start = true
		else:
			await get_tree().create_timer(0.2).timeout
			ui.visible = false
			Globals.dialogue_end = true
			Globals.dialogue_start = false
