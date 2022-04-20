extends ColorRect


func _ready():
	$VBoxContainer/TextureRect.texture.viewport_path = $Viewport.get_path()
	$Timer.start($AudioStreamPlayer.stream.get_length())
	$AudioStreamPlayer.play()


func _on_Timer_timeout():
	get_tree().quit(0)


func _on_Label_meta_clicked(meta: String):
	OS.shell_open(meta)


func _notification(what):
	match what:
		NOTIFICATION_WM_QUIT_REQUEST:
			get_tree().quit()

func _on_StartTimer_timeout():
	$Viewport/AnimationPlayer.play("RotatingLogo")
