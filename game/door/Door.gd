tool
extends KinematicBody2D

onready var sprite = $Sprite
onready var shape = $CollisionShape2D

export(bool) var open = false setget set_open

func set_open(value):
	open = value
	sprite.visible = not open
	shape.disabled = open