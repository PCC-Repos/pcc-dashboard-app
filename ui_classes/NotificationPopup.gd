extends Control


export var fade_time: float = 0.5
export var wait_time: float = 3
export var height: float = 60

enum Type {
	Error,
	Warning
}

var error: bool = true
var text: String = "" setget set_text

onready var popup_panel: = $"%NotifPopup"
onready var tween: SceneTreeTween = popup_panel.create_tween()


func set_text(new: String):
	if not new.empty():
		text = new
		$"%Text".text = text
		popup_panel.rect_global_position.x = OS.window_size.x / 2
		yield(get_tree(), "idle_frame")
		popup_panel.set_anchors_preset(7)
		popup_panel.rect_size = Vector2.ZERO
		yield(get_tree(), "idle_frame")
		tween.kill()
		tween = popup_panel.create_tween()
		tween_sequence()
		tween.play()


func _ready() -> void:
	tween_sequence()


func tween_sequence():
	popup_panel.self_modulate = Color.white
	popup_panel.rect_global_position.x = OS.window_size.x/2 - popup_panel.rect_size.x/2
#	modulate.a = 0
# warning-ignore:return_value_discarded
	tween.set_trans(Tween.TRANS_BACK).set_parallel()
# warning-ignore:return_value_discarded
	tween.tween_property(popup_panel, "rect_position:y", height, fade_time)
# warning-ignore:return_value_discarded
	tween.tween_property(popup_panel, "modulate:a", 1.0, fade_time).from(0.0)

	if text.begins_with("Error:\n"):
# warning-ignore:return_value_discarded
		tween.tween_property(popup_panel, "modulate:r", 5.0, wait_time/3)
	elif text.begins_with("Warning:\n"):
# warning-ignore:return_value_discarded
		tween.tween_property(popup_panel, "self_modulate:r", 3.0, wait_time/3)
# warning-ignore:return_value_discarded
		tween.tween_property(popup_panel, "self_modulate:g", 3.0, wait_time/3)
	else:
		popup_panel.self_modulate = Color.white

# warning-ignore:return_value_discarded
	tween.tween_interval(wait_time)
# warning-ignore:return_value_discarded
	tween.chain().tween_property(popup_panel, "rect_position:y", -popup_panel.rect_size.y, fade_time)
# warning-ignore:return_value_discarded
	tween.tween_property(popup_panel, "modulate:a", 0.0, fade_time)
	error = false
	tween.stop()

