extends PopupMenu


var tween_speed: = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("visibility_changed", self, "_on_visibily_changed")


func _on_visibility_changed():
	var tween: SceneTreeTween = create_tween()
	if visible:
		tween.tween_property(self, "rect_scale:y", 1, 1/tween_speed)
	else:
		tween.tween_property(self, "rect_scale:y", 0, 1/tween_speed)
