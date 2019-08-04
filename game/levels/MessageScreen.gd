tool
extends Control

signal done

export(String) var text = 'Generic text screen' setget set_text
export(Color) var color = Color.whitesmoke setget set_color

func _ready():
	$AnimationPlayer.play('idle')

func _input(event):
	handle_input(event)

func _unhandled_input(event):
	handle_input(event)

func set_text(text):
	$Primary.text = text
	
func set_color(color):
	$Primary.color = color
	
func handle_input(event):
	if event is InputEventKey and event.is_pressed():
		emit_signal('done')