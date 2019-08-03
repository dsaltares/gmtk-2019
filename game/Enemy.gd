extends KinematicBody2D

const MAX_SPEED = 150

onready var sprite = $AnimatedSprite
var path = PoolVector2Array() setget set_path
var is_moving = false
var is_facing_left = false

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta) -> void:
	update_movement(delta)
	update_animation()
	
func update_movement(delta) -> void:
	var max_distance = MAX_SPEED * delta
	var starting_position= position
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

func set_path(value: PoolVector2Array) -> void:
	path = value
	
	if value.size() != 0:
		set_physics_process(true)
