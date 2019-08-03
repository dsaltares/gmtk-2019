extends Node

const LEVELS = [
	'res://levels/LevelOne.tscn',
	'res://levels/LevelTwo.tscn',
	'res://levels/LevelThree.tscn',
]

var current_level = null
var current_level_idx = 0

func _ready():
	go_to_level(LEVELS[0])

func go_to_level(path):
	call_deferred('deferred_go_to_level', path)
	
func deferred_go_to_level(path):
	if (current_level):
		current_level.free()
		
	for projectile in get_tree().get_nodes_in_group('projectiles'):
		projectile.free()
		
	var scene = ResourceLoader.load(path)
	current_level = scene.instance()
	
	get_tree().get_root().add_child(current_level)
	get_tree().set_current_scene(current_level)
	
	connect_to_doors()
		
func connect_to_doors():
	for door in get_tree().get_nodes_in_group('doors'):
		door.connect('player_exited', self, 'on_Door_player_exited')
		
func on_Door_player_exited():
	current_level_idx = clamp(current_level_idx + 1, 0, LEVELS.size() - 1)
	go_to_level(LEVELS[current_level_idx])