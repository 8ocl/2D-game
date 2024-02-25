extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_2d = $RayCast2D

var walking = false
var idle = false
var jumping = false
var gravity_force = 0.68

const SPEED = 150.0
const JUMP_VELOCITY = -270.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta * gravity_force

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		


	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# WALK ANIMATION
	if velocity.x < 0:
		animated_sprite_2d.play("walk")
		animated_sprite_2d.flip_h = true
		ray_cast_2d.rotation = 90
		walking = true
	elif velocity.x > 0:
		animated_sprite_2d.play("walk")
		animated_sprite_2d.flip_h = false
		ray_cast_2d.rotation = -90
		walking = true
	else:
		walking = false
	# IDLE ANIMATION
	if ray_cast_2d.rotation == -90 && walking == false:
		animated_sprite_2d.play("idle")
		animated_sprite_2d.flip_h = false
		idle = true
	elif ray_cast_2d.rotation == 90 && walking == false:
		animated_sprite_2d.play("idle")
		animated_sprite_2d.flip_h = true
		idle = true
	# JUMP ANIMATION
	if !is_on_floor() && ray_cast_2d.rotation == -90:
		animated_sprite_2d.play("jump")
		animated_sprite_2d.flip_h = false
		jumping = true
	elif !is_on_floor() && ray_cast_2d.rotation == 90:
		animated_sprite_2d.play("jump")
		animated_sprite_2d.flip_h = true
		jumping = true

	move_and_slide()

	
	
	
	
