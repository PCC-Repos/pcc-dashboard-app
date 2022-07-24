extends Button

export var tab_container: NodePath


func _ready() -> void:
	connect("toggled", self, "_on_toggled")


func _get_configuration_warning() -> String:
	if not tab_container:
		return "Please provide the TabContainer for this TabButton."

	return ""


func _on_toggled(button_pressed: bool) -> void:
	if button_pressed:
		get_node(tab_container).current_tab = get_index()
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP
