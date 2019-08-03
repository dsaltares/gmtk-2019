extends KinematicBody2D

signal toggled

onready var animated_sprite = $AnimatedSprite

var toggled = false

func toggle():
	toggled = not toggled
	animated_sprite.play('on' if toggled else 'off')
	emit_signal('toggled', toggled)