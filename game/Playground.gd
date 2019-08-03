extends Node2D

signal player_moved

func _on_Player_position_changed(player_position):
	emit_signal("player_moved", player_position)