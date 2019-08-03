tool
extends AnimatedSprite

const Items = preload('res://Items.gd')
const red_frames = preload('res://switch/red_frames.tres')
const blue_frames = preload('res://switch/blue_frames.tres')

signal toggled
signal camera_shake_requested

onready var area = $Area2D

export(bool) var toggled = false setget toggle
export(Items.Colors) var color = Items.Colors.RED setget set_color

func _ready():
	for door in get_tree().get_nodes_in_group('doors'):
		if color == door.color:
			self.connect('toggled', door, 'set_open')
			
	area.connect('body_entered', self, 'on_Area2D_body_entered')

func toggle(value=null):
	if value == null:
		toggled = not toggled
	else:
		toggled = value

	play('on' if toggled else 'off')
	emit_signal('toggled', toggled)
	emit_signal('camera_shake_requested', 2.0, 0.50)
	

func set_color(new_color):
	color = new_color
	var new_frames = red_frames
	match color:
		Items.Colors.RED:
			new_frames = red_frames
		Items.Colors.BLUE:
			new_frames = blue_frames
	self.frames = new_frames

func on_Area2D_body_entered(body):
	if body.is_in_group('projectiles') and body.color == color:
		toggle()