extends KinematicBody2D

const MAX_SPEED = 300
const TIME_TO_MAX_SPEED = 0.2
const TIME_TO_HALT = 0.4
const LIFE_TIME = 0.6

const ACCELERATION = MAX_SPEED / TIME_TO_MAX_SPEED
const DECELERATION = -MAX_SPEED / TIME_TO_HALT

var speed = 0
var life_time = 0
var direction = Vector2.ZERO

func _physics_process(delta):
	if life_time < LIFE_TIME:
		speed += ACCELERATION * delta
	else:
		speed += DECELERATION * delta
		
	life_time += delta
	speed = clamp(speed, 0, MAX_SPEED)
		
	var motion = direction * speed * delta
	var collision = move_and_collide(motion)
	
	if collision != null:
		var collider = collision.collider
		if collider.is_in_group('player'):
			collider.pick_up_ammo()
			queue_free()
		else:
			direction = direction - 2 * (direction.dot(collision.normal)) * collision.normal