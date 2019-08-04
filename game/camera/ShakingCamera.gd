extends Camera2D

onready var timer = $Timer

const AMPLITUDE = 0.6
const DURATION = 0.1
const DAMP_EASING = 1.0

var shake = false setget set_shake
var amplitude = 0
var duration = 0

func _ready():
	randomize()
	
func _process(delta):
	connect_to_shakers()
	update_shake()	
	
func _on_Timer_timeout():
	shake = false
	
func _on_camera_shake_requested(amplitude, duration):
	self.amplitude = amplitude
	self.duration = duration
	self.shake = true
	
func set_shake(value):
	shake = value
	set_process(shake)
	offset = Vector2()
	if value:
		timer.wait_time = DURATION
		timer.start()
	else:
		amplitude = AMPLITUDE
		duration = DURATION
		
func update_shake():
	if not shake:
		return
	
	var damping = ease(timer.time_left / timer.wait_time, DAMP_EASING)
	offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping
	)
		
func connect_to_shakers():
	for camera_shaker in get_tree().get_nodes_in_group('camera_shakers'):
		if not camera_shaker.is_connected("camera_shake_requested", self, "_on_camera_shake_requested"):
			camera_shaker.connect('camera_shake_requested', self, '_on_camera_shake_requested')