extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_2d = $RayCast2D
@onready var coyotetimer = $coyotetimer

const SPEED = 150
const JUMP_VELOCITY = -300.0
var animation_playing = false
var attacking = false
var gravity_force = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# GRAVITY
	if not is_on_floor():
		velocity.y += (gravity * delta) * gravity_force
	# JUMP
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# GET DIRECTION, LEFT OR RIGHT
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# WALKING ANIMATION
	if attacking == false && velocity.x < 0:
		animated_sprite_2d.play("left_walk")
		ray_cast_2d.rotation = 90
		animation_playing = true
		if !is_on_floor() and velocity.x < 0:
			animated_sprite_2d.play("left_walk_shadowless")
	elif attacking == false && velocity.x > 0:
		animated_sprite_2d.play("right_walk")
		ray_cast_2d.rotation = -90
		animation_playing = true
		if !is_on_floor() and velocity.x > 0:
			animated_sprite_2d.play("right_walk_shadowless")
	else:
		animation_playing = false
			
	# CHECK IF YOU'RE IDLING
	if attacking == false && ray_cast_2d.rotation == -90 && animation_playing == false:
		animated_sprite_2d.play("right_idle")
		animation_playing = true
		if !is_on_floor():
			animated_sprite_2d.play("right_idle_shadowless")
	elif attacking == false && ray_cast_2d.rotation == 90 && animation_playing == false:
		animated_sprite_2d.play("left_idle")
		animation_playing = true
		if !is_on_floor():
			animated_sprite_2d.play("right_idle_shadowless")
	# CHECK IF YOU CAN ATTACK, PLAYS ANIMATION
	if ray_cast_2d.rotation == 90 && Input.is_action_just_pressed("click") && !Input.is_action_pressed("left"):
		attacking = true
		if animated_sprite_2d.animation != "left_attack":
			animated_sprite_2d.play("left_attack")
	elif ray_cast_2d.rotation == -90 && Input.is_action_just_pressed("click") && !Input.is_action_pressed("right"):
		attacking = true
		if animated_sprite_2d.animation != "right_attack":
			animated_sprite_2d.play("right_attack")
			
	# ATTACKING ANIMATION END
	if attacking:
		velocity.x = 0
		if animated_sprite_2d.animation == "right_attack" and animated_sprite_2d.frame >= 5:
			attacking = false
			velocity.x = direction
		elif animated_sprite_2d.animation == "left_attack" and animated_sprite_2d.frame >= 5:
			attacking = false


	move_and_slide()

