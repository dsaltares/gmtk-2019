tool
extends Control

signal done

export(String) var text = 'Generic text screen' setget set_text
export(Color) var color = Color.whitesmoke setget set_color

func _ready():
	$AnimationPlayer.play('idle')

func _input(event):
	if event is InputEventKey and event.is_pressed():
		emit_signal('done')

func set_text(text):
	$Primary.text = text
	
func set_color(color):
	$Primary.color = color