extends Control


export var fade_time: float = 0.5
export var wait_time: float = 3
export var height: float = 60

enum Type {
	Normal,
	Warning,
	Error
}

var text: String = ""

onready var popup_panel: = $"%NotifPopup"
onready var tween: SceneTreeTween = popup_panel.create_tween()


func set_text(new: String, type: int = Type.Normal):
	if not new.empty():
		text = new
		$"%Text".text = text
		$"%Text".percent_visible = 0.0
		yield(get_tree(), "idle_frame")
		popup_panel.set_anchors_preset(7)
		popup_panel.rect_size = Vector2.ZERO
		yield(get_tree(), "idle_frame")
		popup_panel.rect_global_position.x = OS.window_size.x/2 - popup_panel.rect_size.x/2
		tween.kill()
		tween = popup_panel.create_tween()
		tween_sequence(type)
		tween.play()


func _ready() -> void:
	tween_sequence(Type.Normal)


func tween_sequence(type: int):
#	modulate.a = 0
# warning-ignore:return_value_discarded
	tween.set_trans(Tween.TRANS_BACK).set_parallel()
# warning-ignore:return_value_discarded
	tween.tween_property(popup_panel, "rect_position:y", height, fade_time)
	tween.tween_property($"%Text", "percent_visible", 1.0, wait_time/1.5)
# warning-ignore:return_value_discarded
	tween.tween_property(popup_panel, "modulate:a", 1.0, fade_time).from(0.0)

	if type == Type.Error:
# warning-ignore:return_value_discarded
		tween.tween_property(popup_panel, "modulate:r", 5.0, wait_time/3)
	elif type == Type.Warning:
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
	tween.stop()

