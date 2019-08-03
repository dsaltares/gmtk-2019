
extends KinematicBody2D

const Items = preload('res://Items.gd')
const red_weapon = preload('res://wizzard/weapon_red_magic_staff.png')
const blue_weapon = preload('res://wizzard/weapon_blue_magic_staff.png')

signal camera_shake_requested
signal position_changed

const MAX_SPEED = 200
const TIME_TO_MAX_SPEED = 0.2
const TIME_TO_HALT = 0.1

onready var ACCELERATION = MAX_SPEED / TIME_TO_MAX_SPEED
onready var DECELERATION = -MAX_SPEED / TIME_TO_HALT

onready var sprite = $AnimatedSprite
onready var weapon = $WeaponPivot
onready var shoot_position = $WeaponPivot/ShootPoint
onready var weapon_raycast = $WeaponPivot/RayCast2D
onready var pickup_animation = $PickUp/AnimationPlayer

var Projectile = preload('res://projectile/Projectile.tscn');

var velocity = Vector2(0, 0)
var last_horizontal_dir = 0
var color = Items.Colors.RED setget set_color

var can_shoot = true

func _ready():
	emit_signal("position_changed", position)

func _physics_process(delta):
	update_movement(delta)
	update_weapon()
	update_animation()


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

	if speed > 0:
		emit_signal("position_changed", global_position)

	sprite.flip_h = last_horizontal_dir < 0
	move_and_slide(velocity)

func update_weapon():
	var look_vec = get_global_mouse_position() - global_position
	weapon.global_rotation = atan2(look_vec.y, look_vec.x)

	if can_shoot and not weapon_raycast.is_colliding() and Input.is_action_just_pressed("shoot"):
		var projectile = Projectile.instance()
		projectile.global_position = shoot_position.global_position
		projectile.direction = (shoot_position.global_position - global_position).normalized()
		projectile.connect('collide_with_player', self, 'pick_up_ammo')
		projectile.shooter = self
		projectile.color = color
		get_tree().get_root().add_child(projectile)
		can_shoot = false

func update_animation():
	var animation = null
	if velocity.length_squared() > 0:
		animation = 'run'
	else:
		animation = 'idle'

	if animation != sprite.animation and animation != null:
		sprite.animation = animation

func pick_up_ammo():
	pickup_animation.play("pickup")
	can_shoot = true
	
func set_color(new_color):
	color = new_color
	var texture = red_weapon
	match color:
		Items.Colors.RED:
			texture = red_weapon
		Items.Colors.BLUE:
			texture = blue_weapon
	$WeaponPivot/Weapon.texture = texture
