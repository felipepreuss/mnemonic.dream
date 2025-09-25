extends CharacterBody3D

class_name NPC
var show_dialogue = true
var change_dialogue = false
@export var player : CharacterBody3D

enum {IDLE,CHASE,ATTACK,RETREAT,DEATH,SHOOT,ANGRY}
var current_state = 0
var state_start = true

func _ready():
	pass

func _physics_process(delta: float) -> void:
	match current_state:
		IDLE:
			idle_state(delta)
		CHASE:
			chase_state(delta)
func idle_state(delta):
	var current_location = global_transform.origin
	var new_velocity = (current_location).normalized() 
	velocity = Vector3(0,0,0)
	rotation.x = 0
	move_and_slide()
func chase_state(delta):
	var current_location = global_transform.origin
	var new_velocity = (current_location).normalized() 
	velocity = Vector3(0,0,0)
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	move_and_slide()


func _on_interact_box_body_entered(body: Node3D) -> void:
	if body.name == "player":
		set_state(CHASE)
func _on_interact_box_body_exited(body: Node3D) -> void:
	if body.name == "player":
		set_state(IDLE)

func set_state(novo_estado):
	if novo_estado != current_state:
		current_state = novo_estado
		state_start = true

func dialogue():
		if change_dialogue == true and show_dialogue == false:
			Dialogue.dialogo = load('res://Script/Dialogos/test_npc1.tres')
			change_dialogue = false
		if show_dialogue:
			Dialogue.dialogo = load('res://Script/Dialogos/test_npc.tres')
			show_dialogue = false
			change_dialogue = true
