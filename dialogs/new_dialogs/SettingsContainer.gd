extends VBoxContainer


func _ready() -> void:
	Settings.get_setting("Basic")

func _on_Glow_toggled(button_pressed: bool) -> void:
	get_tree().current_scene.get_node("WorldEnvironment").environment.glow_enabled = button_pressed
	Settings.set_setting("Basic", "Glow", button_pressed)


func _on_Music_toggled(button_pressed: bool) -> void:
	Settings.set_setting("Basic", "Music", button_pressed)
	var audio_node: AudioStreamPlayer
	var tween: SceneTreeTween = create_tween().set_trans(Tween.TRANS_EXPO).set_parallel()
	if button_pressed:
		tween.set_ease(Tween.EASE_OUT)
		audio_node = get_tree().current_scene.get_node("AdminForm").get_node("AudioStreamRandomPlayer")
		tween.tween_property(audio_node, "volume_db", 0.0, 1.5)
		audio_node = get_tree().current_scene.get_node("AudioStreamPlayer")
		tween.tween_property(audio_node, "volume_db", 0.0, 1.5)
	else:
		tween.set_ease(Tween.EASE_IN)
		audio_node = get_tree().current_scene.get_node("AdminForm").get_node("AudioStreamRandomPlayer")
		tween.tween_property(audio_node, "volume_db", -80.0, 1.5)
		audio_node = get_tree().current_scene.get_node("AudioStreamPlayer")
		tween.tween_property(audio_node, "volume_db", -80.0, 1.5)
#	audio_node.stream_paused = not button_pressed
#	audio_node.stream_paused = not button_pressed
