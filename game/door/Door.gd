tool
extends KinematicBody2D

const Items = preload('res://Items.gd')

onready var sprites = [$Sprite, $Sprite2]
onready var shape = $CollisionShape2D

export(bool) var open = false setget set_open
export(Items.Colors) var color = Items.Colors.RED

var initial_layer;
var initial_mask

func _ready():
	initial_layer = collision_layer
	initial_mask = collision_mask
	
	for sprite in sprites:		
		sprite.modulate = Items.to_color(color)

func set_open(value):
	open = value
	for sprite in sprites:
		sprite.visible = not open
	
	collision_layer = 0 if open else initial_layer
	collision_mask = 0 if open else initial_mask
