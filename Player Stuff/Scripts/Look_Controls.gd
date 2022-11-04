extends Node3D

const MOUSE_SENS : float = 3.0

var mouse_mov
var sway_threshold = 100
var sway_lerp = 10

@export var sway_left : Vector3
@export var sway_right : Vector3
@export var sway_normal : Vector3

#Variable for weapon position
var cam_pos : Vector2



#Variables referencing nodes
@onready var character : CharacterBody3D = get_parent()
@onready var hand = $Camera/Weapons
#@onready var gun = $Camera/Playerhand/scene
@onready var camera = $Camera
@onready var guncam = $Camera/GunRenderContainer/SubViewport/Guncam

func _process(delta):
	#render gun on second layer	
	guncam.global_transform = camera.global_transform


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			mouse_mov = -event.relative.x
			rotation.x -= event.relative.y * MOUSE_SENS * 0.001
			rotation.x = clamp(rotation.x, -1.5, 1.5)
			
			character.rotation.y -= event.relative.x * MOUSE_SENS * 0.001
			character.rotation.y = wrapf(character.rotation.y, 0.0, TAU)
			
func _physics_process(delta):
	
	var is_on_floor = character.is_on_floor()
	
	#if (is_on_floor && Input.get_vector("left", "right", "up", "down")):
		#gun.walk()
	
	if mouse_mov != null:
		if mouse_mov > sway_threshold:
			hand.rotation = hand.rotation.lerp(sway_left, sway_lerp * delta)
		elif mouse_mov < sway_threshold:
			hand.rotation = hand.rotation.lerp(sway_right, sway_lerp * delta)
		else: 
			hand.rotation = hand.rotation.lerp(sway_normal, sway_lerp * delta)
	$Camera.transform.origin.x = cam_pos.y 
	$Camera.transform.origin.y = cam_pos.x 
	

