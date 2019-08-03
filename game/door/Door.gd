tool
extends KinematicBody2D

const Items = preload('res://Items.gd')

const red_spell = preload('res://door/red_spell.png')
const blue_spell = preload('res://door/blue_spell.png')

signal player_exited

onready var shape = $CollisionShape2D

export(bool) var open = false setget set_open
export(Items.Colors) var color = Items.Colors.RED setget set_color

var initial_layer;
var initial_mask

func _ready():
	initial_layer = collision_layer
	initial_mask = collision_mask
	$Spell1/AnimationPlayer.play("idle")
	$Spell2/AnimationPlayer.play("idle")
	
	$Area2D.connect('body_entered', self, 'on_Area2D_body_entered')

func set_open(value):
	open = value
	
	$Spell1/Sprite.visible = not open
	$Spell2/Sprite.visible = not open
	
	collision_layer = 0 if open else initial_layer
	collision_mask = 0 if open else initial_mask

func set_color(new_color):
	color = new_color
	var texture = red_spell
	match color:
		Items.Colors.RED:
			texture = red_spell
		Items.Colors.BLUE:
			texture = blue_spell
	
	$Spell1/Sprite.texture = texture
	$Spell2/Sprite.texture = texture

func on_Area2D_body_entered(body):
	if body.is_in_group('player'):
		emit_signal('player_exited')