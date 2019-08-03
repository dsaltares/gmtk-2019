extends KinematicBody2D

const SPEED = 300

var direction = Vector2.ZERO

func _physics_process(delta):
	var collision = move_and_collide(direction * SPEED * delta)
	if collision != null:
		direction = direction - 2 * (direction.dot(collision.normal)) * collision.normal