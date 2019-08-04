extends Node

var crosshair = load('res://crosshair/crosshair.png')

func _ready():
	Input.set_custom_mouse_cursor(crosshair, 0, Vector2(31,31))