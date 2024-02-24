extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_2d = $RayCast2D


const SPEED = 150
const JUMP_VELOCITY = -400.0
var animation_playing = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta


	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	# animation
	if velocity.x < 0:
		animated_sprite_2d.play("left_walk")
		ray_cast_2d.rotation = 90
		animation_playing = true
	elif velocity.x > 0:
		animated_sprite_2d.play("right_walk")
		ray_cast_2d.rotation = -90
		animation_playing = true
	else:
		animation_playing = false
	
	if ray_cast_2d.rotation == -90 && animation_playing == false:
		animated_sprite_2d.play("right_idle")
	elif ray_cast_2d.rotation == 90 && animation_playing == false:
		animated_sprite_2d.play("left_idle")

	move_and_slide()
