extends Control


onready var content_scroll = $ScrollContainer

func _ready() -> void:
	connect("visibility_changed", self, "_on_visibility_changed") # warning-ignore:return_value_discarded

func _on_visibility_changed() -> void:
	if visible:
		var tween: = create_tween()
		rect_pivot_offset = rect_size/2
		tween.tween_property(self, "rect_scale:y", 1.0, 0.3/owner.speed).from(0.0) # warning-ignore:return_value_discarded
		owner.get_recursive_children(self)
