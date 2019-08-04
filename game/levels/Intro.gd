extends Node2D

signal done

var skipped = false

func _input(event):
	var is_key = event is InputEventKey
	var is_mouse = event is InputEventMouseButton
	var is_skip_event = is_key or is_mouse
	if not skipped and is_skip_event :
		emit_signal('done')
		skipped = true
