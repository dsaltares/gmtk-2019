extends Node2D

func _on_Player_position_changed(player_position):
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	for i in enemies.size():
		var enemy = enemies[i]
		enemy.path = $Navigation2D.get_simple_path(enemy.position, player_position, false)

func _on_Enemy_player_killed():
	$Player.kill()
