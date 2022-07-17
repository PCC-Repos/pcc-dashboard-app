extends Control


onready var content_scroll = $ScrollContainer


func _on_Transactions_visibility_changed() -> void:
	if visible:
		var tween: = create_tween()
		rect_pivot_offset = rect_size/2
		tween.tween_property(self, "rect_scale:y", 1.0, 0.3/owner.speed).from(0.0)
		owner.get_recursive_children(self)
