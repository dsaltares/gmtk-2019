extends KinematicBody2D

const MAX_SPEED = 150
const TIME_TO_MAX_SPEED = 0.2
const TIME_TO_HALT = 0.1

onready var ACCELERATION = MAX_SPEED / TIME_TO_MAX_SPEED
onready var DECELERATION = -MAX_SPEED / TIME_TO_HALT

onready var sprite = $AnimatedSprite

var velocity = Vector2(0, 0)
var last_horizontal_dir = 0
var target_position = Vector2(0, 0)

func _ready():
	$DirectionTimer.start()

func _physics_process(delta):
	update_movement(delta)
	update_animation()
	
func update_movement(delta):
	var move_dir = Vector2(
		target_position.x - position.x,
		target_position.y - position.y
	)
	
	var distance_to_target = move_dir.length_squared()
	
	if position.distance_squared_to(target_position) > 100:
		var path = $Navigation2D.get_simple_path(global_position, target_position)
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
			
func update_animation():
	var animation = null
	if velocity.length_squared() > 0:
		animation = 'run'
	else:
		animation = 'idle'
	
	if animation != sprite.animation and animation != null:
		sprite.animation = animation

func _on_player_moved(player_position):
	target_position = player_position
