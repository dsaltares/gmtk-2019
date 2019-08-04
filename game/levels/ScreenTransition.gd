extends Control

signal done

func _ready():
	$AnimationPlayer.connect('animation_finished', self, 'on_AnimationPlayer_animation_finished')

func play(anim):
	$AnimationPlayer.play(anim)

func on_AnimationPlayer_animation_finished(anim_name):
	emit_signal('done')