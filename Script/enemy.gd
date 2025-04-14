extends CharacterBody3D
@export var player : CharacterBody3D
const SPEED = 1.25
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var vida = 200

#var LOW_DAMAGE = randf_range(1,20)
#var MEDIUM_DAMAGE = randf_range(21,50)
#var BIG_DAMAGE = randf_range(51,100)
#var CRITICAL_DAMAGE = randf_range(101,200)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	look_at(player.global_position, Vector3(0,1,0))
	rotation.x = 0
	rotation.z = 0
	var direction= (player.global_position - global_transform.origin).normalized()
	#position.y = 0
	velocity = direction * SPEED
	#rotation.z = lerp_angle(rotation.z,deg_to_rad(90),10 * delta)
	move_and_slide()

func calcularDano(dano:int):
	vida -= dano
	if vida <= 0:
		queue_free()
 
