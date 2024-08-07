extends CharacterBody2D

const SPEED = 300.0
const SLOW_SPEED = 150.0
const BOUNCE_SPEED = 0.15
const MAX_JUMP_TIME = 0.3  # Maximum time the jump force is applied
const MAX_BOUNCE_TIME = 0.1  # Maximum time for the bounce effect
const JUMP_FORCE = -1900.0  # Force applied while the jump key is held
const JUMP_INITIAL_FORCE = -600.0  # Initial force applied when jump starts

@onready var sprite_2d = $Sprite2D
@onready var game_manager = %GameManager
@onready var bounce_timer = $BounceTimer
@onready var boost_timer = $BoostTimer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1
var jump_time = 0.0
var is_jumping = false
var current_speed = SPEED
var multiplier = 1.0
var jumpMulti = 1.0


func _enter_tree():
	set_multiplayer_authority(name.to_int())

func jump_speed():
	$BounceTimer.start()  # Start the bounce timer
	multiplier = 1.5
	velocity.y = JUMP_FORCE * 0.6
	
func boost_speed():
	$BoostTimer.start()
	multiplier = 2.5
	jumpMulti = 1.5
	
func reset_speed():
	multiplier = 1.0  # Reset the multiplier to normal
	jumpMulti = 1.0

func _physics_process(delta):
	# Add running animation
	if abs(velocity.x) > 1:
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "idle"

	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 0:
			sprite_2d.animation = "fall"
		else:
			sprite_2d.animation = "jumping"
	else:
		is_jumping = false
	current_speed = SPEED
	# Handle jump
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_jumping = true
		jump_time = 0.0
		velocity.y = JUMP_INITIAL_FORCE * jumpMulti
		game_manager.add_jumps()
			
	if Input.is_action_pressed("slow"):
		current_speed = SLOW_SPEED
		
	if is_jumping and Input.is_action_pressed("jump") and jump_time < MAX_JUMP_TIME:
		velocity.y += JUMP_FORCE * delta
		jump_time += delta
		
	if Input.is_action_just_pressed("reset"):
		position.x = 161
		position.y = 500
		print("reset")

	if not Input.is_action_pressed("jump"):
		is_jumping = false

	#if Input.is_action_just_pressed("change"):
		#direction *= -1

	# Automatic movement
	velocity.x = direction * current_speed * multiplier

	# Move and detect collision
	move_and_slide()

	# Check for wall collisions and change direction if needed
	if is_on_wall():
		direction *= -1
		game_manager.add_bumps()
		
	var isLeft = direction < 0
	sprite_2d.flip_h = isLeft

func _on_bounce_timer_timeout():
	reset_speed()
	print("bounce")

func _on_boost_timer_timeout():
	reset_speed()
	print("speed")
