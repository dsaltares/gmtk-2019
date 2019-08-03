tool
extends KinematicBody2D

const Items = preload('res://Items.gd')

onready var sprite = $Sprite
onready var shape = $CollisionShape2D

export(bool) var open = false setget set_open
export(Items.Colors) var color = Items.Colors.RED

func _ready():
	sprite.modulate = Items.to_color(color)

func set_open(value):
	open = value
	sprite.visible = not open
	shape.disabled = open
