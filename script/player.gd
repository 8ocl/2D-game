extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var looking_dir = $looking_dir
@onready var coyotetimer = $coyotetimer


var walking = false
var idle = false
var jumping = false
var gravity_force = 3

var coyote = 2
var can_jump = true

const SPEED = 700
const JUMP_VELOCITY = -1200

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta * gravity_force


	if is_on_floor() && can_jump == false:
		can_jump = true
	elif can_jump == true && $coyotetimer.is_stopped():
		$coyotetimer.start(coyote)

	if can_jump == true:
		if Input.is_action_just_pressed("ui_accept"):
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
		looking_dir.rotation = 90
		walking = true
	elif velocity.x > 0:
		animated_sprite_2d.play("walk")
		animated_sprite_2d.flip_h = false
		looking_dir.rotation = -90
		walking = true
	else:
		walking = false
		
	# IDLE ANIMATION
	if looking_dir.rotation == -90 && walking == false:
		animated_sprite_2d.play("idle")
		animated_sprite_2d.flip_h = false
		idle = true
	elif looking_dir.rotation == 90 && walking == false:
		animated_sprite_2d.play("idle")
		animated_sprite_2d.flip_h = true
		idle = true
		
	# JUMP ANIMATION
	if !is_on_floor() && looking_dir.rotation == -90:
		animated_sprite_2d.play("jump")
		animated_sprite_2d.flip_h = false
		jumping = true
	elif !is_on_floor() && looking_dir.rotation == 90:
		animated_sprite_2d.play("jump")
		animated_sprite_2d.flip_h = true
		jumping = true

	move_and_slide()

func _on_coyotetimer_timeout():
	can_jump = false
