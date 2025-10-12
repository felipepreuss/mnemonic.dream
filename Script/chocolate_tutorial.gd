extends ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	if visible and Globals.has_seen_tutorial_1 == false:
		animation_player.play("color")
	else:
		visible = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	visible = false
	Globals.has_seen_tutorial_1 = true
