extends ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	if visible:
		animation_player.play("color")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	visible = false
