extends ColorRect

var video_anim_played = false

onready var anim = $Anim
onready var logo = $TextureRect
onready var video_player = $VideoPlayer
onready var audio_player = $AudioStreamPlayer


func _ready():
	if OS.is_debug_build():
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://main.tscn")
		audio_player.play()

	logo.show()
	anim.play("hide_img_rect")


func _on_AnimationPlayer_animation_finished(_anim_name):
	if video_anim_played:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://main.tscn")
	video_player.self_modulate.a = 1
	video_player.play()
	logo.hide()

func _on_VideoPlayer_finished():
	anim.play_backwards("show_splash_screen")
	video_anim_played = true
