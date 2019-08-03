extends KinematicBody2D

const MAX_SPEED = 200
const TIME_TO_MAX_SPEED = 0.2
const TIME_TO_HALT = 0.1

onready var ACCELERATION = MAX_SPEED / TIME_TO_MAX_SPEED
onready var DECELERATION = -MAX_SPEED / TIME_TO_HALT

onready var sprite = $AnimatedSprite
onready var weapon = $WeaponPivot

var velocity = Vector2(0, 0)
var last_horizontal_dir = 0

func _physics_process(delta):
	update_movement(delta)
	update_weapon()
	
func update_movement(delta):
	var move_dir = Vector2(
		float(Input.is_action_pressed("move_right")) - float(Input.is_action_pressed("move_left")),
		float(Input.is_action_pressed("move_down")) - float(Input.is_action_pressed("move_up"))
	)
	move_dir = move_dir.normalized()
	
	var speed = velocity.length()
	if move_dir.length_squared() > 0:
		speed = min(speed + ACCELERATION * delta, MAX_SPEED)
		velocity = move_dir * speed
	else:
		speed = max(speed + DECELERATION * delta, 0)
		velocity = velocity.normalized() * speed
	
	if velocity.x != 0:
		last_horizontal_dir = sign(velocity.x)
	
	sprite.flip_h = last_horizontal_dir < 0
	move_and_slide(velocity)
	
func update_weapon():
	var mouse_position = get_global_mouse_position()
	weapon.look_at(mouse_position)