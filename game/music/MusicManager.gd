extends Node

const FADE_TIME = 0.2

var current_track = null

func _ready():
	$Timer.connect('timeout', self, '_fade_in')

func play(track):
	if current_track == track:
		return
		
	if current_track != null:
		$Tween.interpolate_property(
			$AudioStreamPlayer,
			'volume_db',
			0, -80,
			FADE_TIME,
			Tween.TRANS_QUAD,
			Tween.EASE_IN_OUT
		)
		$Tween.start()
		$Timer.set_wait_time(FADE_TIME)
		$Timer.start()
		current_track = track
	else:
		current_track = track
		_fade_in()
	
func _fade_in():
	$Timer.stop()
	var path = 'res://music/' + current_track + '.ogg';
	var track_resource = ResourceLoader.load(path)
	$AudioStreamPlayer.stream = track_resource
	$AudioStreamPlayer.play()
	$Tween.interpolate_property(
		$AudioStreamPlayer,
		'volume_db',
		-80, 0,
		FADE_TIME,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	$Tween.start()