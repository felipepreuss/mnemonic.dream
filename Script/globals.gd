extends Node

var pop_candy_powerup = false
var chiclete_powerup = false
var contador = 0
var get_chiclete = false
var get_pop_candy = false
var get_chocolate = false
var dialogue_end = false
var dialogue_start = false

@onready var Dialogue = "res://Scenes/dialogue.tscn"

func reset_powerups():
	pop_candy_powerup = false
	chiclete_powerup = false
	get_chiclete = false
	get_pop_candy = false
	get_chocolate = false
