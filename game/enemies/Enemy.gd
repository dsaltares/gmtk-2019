extends KinematicBody2D

signal player_killed

export var MAX_SPEED = 150

onready var sprite = $AnimatedSprite
onready var animation = $AnimationPlayer

var path = PoolVector2Array()
var target = null
var can_see = false
var is_dead = false
var is_moving = false
export(bool) var is_facing_left = false

func _ready() -> void:
	set_physics_process(false)
	sprite.flip_h = is_facing_left

func _physics_process(delta) -> void:
	update_visibility()
	if can_see:
		update_movement(delta)
	update_animation()

func update_visibility():
	if not can_see:
		var space_state = get_world_2d().direct_space_state
		var ray_hit = space_state.intersect_ray(position, target.position, [self], collision_mask)
		if ray_hit:
			var name = ray_hit.collider.name
			if name == "Player" or name == "Projectile":
				if is_facing_left:
					can_see = rad2deg(abs(position.angle_to_point(ray_hit.collider.position))) < 80
				else:
					can_see = rad2deg(abs(position.angle_to_point(ray_hit.collider.position))) > 100

func update_movement(delta) -> void:
	var max_distance = MAX_SPEED * delta
	var starting_position = position
	
	var collision = move_and_collide(Vector2.ZERO)
	if collision != null and collision.collider.is_in_group("player"):
		emit_signal("player_killed")
		collision.collider.add_collision_exception_with(self)
		return

	
	for i in range(path.size()):
		var distance_to_next = starting_position.distance_to(path[0])
		var direction_to_next = starting_position.direction_to(path[0])
		is_moving = false
		is_facing_left = direction_to_next.x < 0
		
		if max_distance <= distance_to_next and max_distance >= 0.0:
			position = starting_position.linear_interpolate(path[0], max_distance / distance_to_next)
			is_moving = true
			break
		elif max_distance < 0.0:
			position = path[0]
			set_physics_process(false)
			break
		
		max_distance -= distance_to_next
		starting_position = path[0]
		path.remove(0)

func update_animation() -> void:
	var animation = null
	if is_moving:
		animation = 'run'
	else:
		animation = 'idle'
	
	if animation != sprite.animation and animation != null:
		sprite.animation = animation
	
	sprite.flip_h = is_facing_left

func kill() -> void:
	set_physics_process(false)
	is_dead = true
	sprite.visible = false
	
	$Effects/Death.play()
	animation.play("death")	
	yield(animation, "animation_finished")

	queue_free()

func _on_Visibility_body_entered(body):
	if not is_dead:
		if body.name == "Player" or body.name == "Projectile":
			target = body
			update_visibility()
			set_physics_process(true)


func _on_Visibility_body_exited(body):
	if body == target and not can_see:
		target = null
		set_physics_process(false)


func _on_Contact_body_entered(body):
	if not is_dead:
		if body.name == "Player":
			set_physics_process(true)
			can_see = true
