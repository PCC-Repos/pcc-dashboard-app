extends Control


export var fade_time: float = 0.5
export var wait_time: float = 3
export var height: float = 60


var text: String = ""

onready var popup_panel: = $"%NotifPopup"
onready var backlight: = $"%Backlight"
onready var tween: SceneTreeTween = popup_panel.create_tween()


func _ready() -> void:
	backlight.rect_size.y = height + popup_panel.rect_size.y
	backlight.self_modulate = 0
	tween_sequence()


# warning-ignore:unused_argument
func _process(delta):
	while NotificationServer.is_notification_available():
		show()
		var notification = NotificationServer.get_notification()
		$"%Text".text = notification[1]
		yield(get_tree(), "idle_frame")
#				popup_panel.set_anchors_preset(7)
		popup_panel.rect_size = Vector2.ZERO
		popup_panel.modulate = Color.white
		yield(get_tree(), "idle_frame")
		popup_panel.rect_global_position = Vector2(OS.window_size.x/2 - popup_panel.rect_size.x/2, -popup_panel.rect_size.y - 10)
		tween.kill()
		tween = popup_panel.create_tween()
		tween_sequence(notification[0])
		tween.play()
		yield(tween, "finished")
		hide()

func tween_sequence(type: int = NotificationServer.INFO):
# warning-ignore:return_value_discarded
	tween.set_trans(Tween.TRANS_QUAD).set_parallel()
	$"%Text".remove_font_override("font")
	match type:
		NotificationServer.ERROR:
# warning-ignore:return_value_discarded
			tween.tween_property(backlight, "self_modulate:r", 5.0, wait_time/3)
		NotificationServer.WARNING:
# warning-ignore:return_value_discarded
			tween.tween_property(backlight, "self_modulate:r", 3.0, wait_time/3)
# warning-ignore:return_value_discarded
			tween.tween_property(backlight, "self_modulate:g", 3.0, wait_time/3)
		_:
			backlight.self_modulate = Color.white
# warning-ignore:return_value_discarded
	tween.tween_property(backlight, "self_modulate:a", 1.0, wait_time/3).from(0.0)
# warning-ignore:return_value_discarded
	tween.set_trans(Tween.TRANS_BACK)
# warning-ignore:return_value_discarded
	tween.tween_property(popup_panel, "rect_position:y", height, fade_time)
# warning-ignore:return_value_discarded
	tween.tween_property($"%Text", "self_modulate:a", 1.0, wait_time/1.5).from(0.0)
# warning-ignore:return_value_discarded
	tween.tween_property($"%Text", "percent_visible", 1.0, wait_time/1.5).from(0.0)
# warning-ignore:return_value_discarded
	tween.tween_property(popup_panel, "modulate:a", 1.0, fade_time).from(0.0)

	match type:
		NotificationServer.ERROR:
# warning-ignore:return_value_discarded
			tween.tween_property(popup_panel, "modulate:r", 5.0, wait_time/3)
		NotificationServer.WARNING:
# warning-ignore:return_value_discarded
			tween.tween_property(popup_panel, "modulate:r", 3.0, wait_time/3)
# warning-ignore:return_value_discarded
			tween.tween_property(popup_panel, "modulate:g", 3.0, wait_time/3)
		NotificationServer.CRITICAL:
# warning-ignore:return_value_discarded
			tween.tween_property(popup_panel, "modulate:r", 5.0, wait_time/3)
			$"%Text".add_font_override("font", load("res://assets/fonts/Bold.tres"))
		_:
			popup_panel.self_modulate = Color.white
# warning-ignore:return_value_discarded
	tween.tween_interval(wait_time)
# warning-ignore:return_value_discarded
	tween.chain().tween_property(popup_panel, "rect_position:y", -popup_panel.rect_size.y, fade_time)
# warning-ignore:return_value_discarded
	tween.tween_property(backlight, "self_modulate:a", 0.0, wait_time/3)
# warning-ignore:return_value_discarded
	tween.tween_property(popup_panel, "modulate:a", 0.0, fade_time)
	tween.stop()
