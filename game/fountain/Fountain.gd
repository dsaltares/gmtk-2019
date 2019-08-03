tool
extends KinematicBody2D

const Items = preload('res://Items.gd')

onready var blue = $Blue
onready var red = $Red

export(Items.Colors) var color = Items.Colors.RED setget set_color

func _ready():
	update_sprites()
			
func set_color(new_color):
	color = new_color
	update_sprites()
	
func update_sprites():
	var blue = $Blue
	var red = $Red
	
	match color:
		Items.Colors.RED:
			red.visible = true
			blue.visible = false
		Items.Colors.BLUE:
			red.visible = false
			blue.visible = true