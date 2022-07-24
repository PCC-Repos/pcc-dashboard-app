extends VBoxContainer


func _ready() -> void:
	connect("visibility_changed", self, "_on_visibility_changed") # warning-ignore:return_value_discarded


func _on_visibility_changed() -> void:
	if visible: owner.get_recursive_children(self)
