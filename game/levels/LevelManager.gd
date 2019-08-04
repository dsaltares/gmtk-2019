extends Node

const Transition = preload('res://levels/ScreenTransition.tscn')
const MessageScreen = preload('res://levels/MessageScreen.tscn')
const Intro = preload('res://levels/Intro.tscn')
const EndGame = preload('res://levels/EndGame.tscn')

const LEVELS = [
	'res://levels/LevelOne.tscn',
	'res://levels/LevelTwo.tscn',
	'res://levels/LevelThree.tscn',
	'res://levels/LevelFour.tscn',
	'res://levels/LevelFive.tscn',
	'res://levels/LevelSix.tscn',
	'res://levels/LevelSeven.tscn',
	'res://levels/LevelEight.tscn',
	'res://levels/LevelNine.tscn',
	'res://levels/LevelTen.tscn',
	
]

enum States {
	INTRO,
	LEVEL_TITLE,
	LEVEL,
	DEATH,
	END_GAME
}

var message_screen = null
var transition = null
var level = null
var intro = null
var end_game = null
var level_idx = 0
var next_state = null

func _ready():
	transition_out(States.INTRO)
	
func transition_out(state):
	next_state = state
	call_deferred('deferred_transition')
	
func deferred_transition():	
	clear_transition()
	transition = Transition.instance()
	transition.play('out')
	transition.connect('done', self, 'on_TransitionOut_done')
	$TransitionLayer.add_child(transition)
	
func on_TransitionOut_done():
	call_deferred('deferred_transition_out')

func deferred_transition_out():
	clear_scene()
	load_next_scene()
	transition_in()

func clear_scene():
	clear_intro()
	clear_level()
	clear_endgame()
	clear_message()
	clear_transition()

func clear_intro():
	if intro:
		intro.free()
		intro = null

func clear_level():
	if level:
		level.free()
		level = null
		
	for projectile in get_tree().get_nodes_in_group('projectiles'):
		projectile.free()

func clear_endgame():
	if end_game:
		end_game.free()
		end_game = null

func clear_transition():
	if transition:
		transition.free()
		transition = null
		
func clear_message():
	if message_screen:
		message_screen.free()
		message_screen = null

func load_next_scene():
	match next_state:
		States.INTRO:
			load_intro()
		States.LEVEL_TITLE:
			load_level_title()
		States.LEVEL:
			load_level()
		States.DEATH:
			load_death_screen()
		States.END_GAME:
			load_end_game()

func transition_in():
	clear_transition()
	transition = Transition.instance()
	transition.play('in')
	transition.connect('done', self, 'on_TransitionIn_done')
	$TransitionLayer.add_child(transition)

func load_intro():
	intro = Intro.instance()
	get_tree().get_root().add_child(intro)
	get_tree().set_current_scene(intro)
	intro.connect('done', self, 'on_Intro_done') 
	$MusicManager.play('intro')

func on_Intro_done():
	transition_out(States.LEVEL_TITLE)

func load_level_title():
	message_screen = MessageScreen.instance()
	message_screen.text = 'Level ' + String(level_idx + 1)
	message_screen.connect('done', self, 'on_LevelTitle_done') 
	get_tree().get_root().add_child(message_screen)
	get_tree().set_current_scene(message_screen)
	$MusicManager.play('game')

func on_LevelTitle_done():
	transition_out(States.LEVEL)

func load_level():
	var path = LEVELS[level_idx]
	var scene = ResourceLoader.load(path)
	level = scene.instance()
	
	get_tree().get_root().add_child(level)
	get_tree().set_current_scene(level)
	
	for door in get_tree().get_nodes_in_group('doors'):
		door.connect('player_exited', self, 'on_Door_player_exited')
		
	for player in get_tree().get_nodes_in_group('player'):
		player.connect('killed', self, 'on_Player_killed')
		
	$MusicManager.play('game')

func on_Door_player_exited():
	if level_idx == LEVELS.size() - 1:
		transition_out(States.END_GAME)
	else:
		level_idx += 1
		transition_out(States.LEVEL_TITLE)

func on_Player_killed():
	transition_out(States.DEATH)

func load_death_screen():
	message_screen = MessageScreen.instance()
	message_screen.text = 'You are dead!'
	message_screen.connect('done', self, 'on_DeathScreen_done') 
	get_tree().get_root().add_child(message_screen)
	get_tree().set_current_scene(message_screen)
	$MusicManager.play('death')

func load_end_game():
	end_game = EndGame.instance()
	get_tree().get_root().add_child(end_game)
	get_tree().set_current_scene(end_game)
	$MusicManager.play('ending')

func on_DeathScreen_done():
	transition_out(States.LEVEL)

func on_TransitionIn_done():
	call_deferred('deferred_transition_in_done')
	
func deferred_transition_in_done():
	if transition:
		transition.free()
		transition = null
		