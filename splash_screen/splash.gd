extends ColorRect

var video_anim_played = false

func _ready():
#	$VideoPlayer.self_modulate.a = 1
	$TextureRect.show()
	$AnimationPlayer.play("show_img_rect")

func _on_AnimationPlayer_animation_finished(anim_name):
	if video_anim_played:
		get_tree().change_scene("res://main.tscn")
	$VideoPlayer.self_modulate.a = 1
	$VideoPlayer.play()
	$TextureRect.hide()
	$AudioStreamPlayer.play()


func _on_VideoPlayer_finished():
	$AnimationPlayer.play_backwards("show_splash_screen")
	video_anim_played = true
