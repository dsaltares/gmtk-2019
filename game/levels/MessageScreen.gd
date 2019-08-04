extends Control

signal done

export(String) var text = 'Generic text screen' setget set_text
export(Color) var color = Color.whitesmoke setget set_color

var skipped = false

func _ready():
	$AnimationPlayer.play('idle')

func _input(event):
	var is_key = event is InputEventKey
	var is_mouse = event is InputEventMouseButton
	var is_skip_event = is_key or is_mouse
	if not skipped and is_skip_event :
		emit_signal('done')
		skipped = true

func set_text(text):
	$Primary.text = text
	
func set_color(color):
	$Primary.color = color
	