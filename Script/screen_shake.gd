# ScreenShake.gd
extends Node3D
 

func screenShake(camera: Camera3D, trauma: float, reduction: float, delta: float) -> void:
	if camera == null or not is_instance_valid(camera):
		return

	var strength = trauma
	var original_transform = camera.transform

	while strength > 0:
		await get_tree().process_frame

		if camera == null or not is_instance_valid(camera):
			return

		var offset = Vector3(
			randf_range(-strength, strength),
			randf_range(-strength, strength),
			randf_range(-strength, strength)
		)

		camera.transform.origin = original_transform.origin + offset
		strength = lerpf(strength, 0.0, reduction * delta)

	if camera != null and is_instance_valid(camera):
		camera.transform = original_transform
