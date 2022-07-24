extends VBoxContainer

onready var glow_btn = $HB/GlowBtn
onready var music_btn = $HB2/MusicBtn

func _ready() -> void:
	glow_btn.connect("toggled", self, "_on_glow_btn_toggled")
	music_btn.connect("toggled", self, "_on_music_btn_toggled")

func _on_glow_btn_toggled(button_pressed: bool) -> void:
	get_tree().current_scene.get_node("WorldEnvironment").environment.glow_enabled = button_pressed
	Settings.set_setting("Basic", "Glow", button_pressed)


func _on_music_btn_toggled(button_pressed: bool) -> void:
	Settings.set_setting("Basic", "Music", button_pressed)
	var tween: SceneTreeTween = create_tween().set_trans(Tween.TRANS_EXPO).set_parallel()

	for audio_player in get_tree().get_nodes_in_group("audio_players"):
		if button_pressed:
			tween.set_ease(Tween.EASE_OUT) # warning-ignore:return_value_discarded
			tween.tween_property(audio_player, "volume_db", 0.0, 1.5) # warning-ignore:return_value_discarded
		else:
			tween.set_ease(Tween.EASE_IN) # warning-ignore:return_value_discarded
			tween.tween_property(audio_player, "volume_db", -80.0, 1.5) # warning-ignore:return_value_discarded
