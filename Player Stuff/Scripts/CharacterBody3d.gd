class_name Player
extends CharacterBody3D


const GRAVITY : float = 15.0
const MAX_SPEED : float = 20.0
const MAX_ACCEL : float = 100.0
const JUMP_FORCE : float = 10-.0
const FRICTION : float = 0.86

const AIR_DRAG : float = 0.90
# Amount of directional control
const CONTROL : float = 10.0


var slide : float
var hvel : Vector3
var dir : Vector3
var height : float
var crouch : float

@onready var weapon_manager = $Head/Camera/Weapons



func _physics_process(delta : float) -> void:
	handle_bounds()
	handle_movement(delta)
	process_weapons()

func handle_bounds() -> void:
	if global_transform.origin.y <= -100.0:
		global_transform.origin = Vector3.ONE

func handle_movement(delta : float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Jumping
	if Input.is_action_pressed("ui_accept") and is_on_floor() and crouch < 0.1:
		velocity.y = JUMP_FORCE

	# Input direction
	var input = Input.get_vector("left", "right", "up", "down")
	
	# Movement direction
	dir = lerp(dir, (transform.basis * Vector3(input.x, 1, input.y)).normalized(), delta * CONTROL)

	# Friction and air drag for horizontal velocity
	hvel = velocity
	hvel.y = 0.0
	var decel = FRICTION if is_on_floor() else AIR_DRAG
	hvel *= decel
	
	# Zero out horizontal velocity if speed is too small
	if hvel.length() < MAX_SPEED * 0.01:
		hvel = Vector3.ZERO
	
	# Acceleration
	# Here lies the strafing mechanic (bug)
	# Projection of the horizontal velocity to the direction
	var speed = hvel.dot(dir)
	# Whenever the amount of acceleration to add is clamped by the maximum acceleration constant
	# Player can make the speed faster by bringing the direction closer to horizontal velocity angle
	# More info here: https://youtu.be/v3zT3Z5apaM?t=165
	var max_speed = MAX_SPEED if crouch < 0.1 else MAX_SPEED * 0.25
	var accel : float = clamp(max_speed - speed, 0.0, MAX_ACCEL * delta)
	hvel += dir * accel
	
	# Apply horizontal velocity to final velocity
	velocity.x = hvel.x
	velocity.z = hvel.z
	
	# Godot's move and slide function
	move_and_slide()

#func handle_interactions() ->void:
	#if Input.is_action_pressed()

func process_weapons():
	
	#Swapping Weapons
	if Input.is_action_just_pressed("empty"):
		weapon_manager.change_weapon("Empty")
	if Input.is_action_just_pressed("primary"):
		weapon_manager.change_weapon("Primary")
		
	#Firing
	if Input.is_action_just_pressed("fire"):
		weapon_manager.fire()
	if Input.is_action_just_released("fire"):
		weapon_manager.fire_stop()
	
	#Reloading
	if Input.is_action_just_pressed("reload"):
		weapon_manager.reload()

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					weapon_manager.next_weapon()
				MOUSE_BUTTON_WHEEL_DOWN:
					weapon_manager.previous_weapon()
	
