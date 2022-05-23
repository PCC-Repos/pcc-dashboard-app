extends PanelContainer


export var fade_time: float = 0.5
export var wait_time: float = 3
export var height: float = 60

var error: bool = true
var text: String = "" setget set_text

onready var tween: SceneTreeTween = create_tween()


func set_text(new):
	if new:
		text = new
		$Label.text = text
		rect_size = Vector2.ZERO
		set_anchors_preset(7)
		yield(get_tree(), "idle_frame")
		tween.kill()
		tween = create_tween()
		tween_sequence()
		tween.play()


func _ready() -> void:
	tween_sequence()


func tween_sequence():
	self_modulate = Color.white
#	modulate.a = 0
# warning-ignore:return_value_discarded
	tween.set_trans(Tween.TRANS_BACK).set_parallel()
# warning-ignore:return_value_discarded
	tween.tween_property(self, "rect_position:y", OS.window_size.y - rect_size.y - height, fade_time)
# warning-ignore:return_value_discarded
	tween.tween_property(self, "modulate:a", 1.0, fade_time).from(0.0)

	if text.begins_with("Error:\n"):
# warning-ignore:return_value_discarded
		tween.tween_property(self, "modulate:r", 5.0, wait_time/3)
	elif text.begins_with("Warning:\n"):
# warning-ignore:return_value_discarded
		tween.tween_property(self, "self_modulate:r", 3.0, wait_time/3)
# warning-ignore:return_value_discarded
		tween.tween_property(self, "self_modulate:g", 3.0, wait_time/3)

# warning-ignore:return_value_discarded
	tween.tween_interval(wait_time)
# warning-ignore:return_value_discarded
	tween.chain().tween_property(self, "rect_position:y", OS.window_size.y + rect_size.y, fade_time)
# warning-ignore:return_value_discarded
	tween.tween_property(self, "modulate:a", 0.0, fade_time)
	error = false
	tween.stop()

