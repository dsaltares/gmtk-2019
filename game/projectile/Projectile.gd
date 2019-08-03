extends KinematicBody2D

signal camera_shake_requested
signal collide_with_player

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
			emit_signal('collide_with_player')
			emit_signal('camera_shake_requested', 2.5, 0.5)
			queue_free()
		elif collider.is_in_group('switches'):
			emit_signal('camera_shake_requested', 2.0, 0.50)
			collider.toggle()
			collider.add_collision_exception_with(self)
		else:
			emit_signal('camera_shake_requested', 1.25, 0.75)
			direction = direction - 2 * (direction.dot(collision.normal)) * collision.normal