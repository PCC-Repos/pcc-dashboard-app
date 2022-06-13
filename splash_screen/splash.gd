extends ColorRect

var video_anim_played = false


func _ready():
	OS.request_permissions()
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(768, 768))
	$TextureRect.show()
	$AnimationPlayer.play("hide_img_rect")
	$AudioStreamPlayer.play()


func _on_AnimationPlayer_animation_finished(_anim_name):
	if video_anim_played:
		get_tree().change_scene("res://main.tscn")
	$VideoPlayer.self_modulate.a = 1
	$VideoPlayer.play()
	$TextureRect.hide()


func _on_VideoPlayer_finished():
	$AnimationPlayer.play_backwards("show_splash_screen")
	video_anim_played = true


func _notification(what):
	match what:
		NOTIFICATION_WM_QUIT_REQUEST:
			get_tree().quit()
