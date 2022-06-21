tool
extends Button

export var tab_container: NodePath

onready var ready: = true

func _get_configuration_warning() -> String:
	if not tab_container: return "Please provide the TabContainer for which this button will switch the tab."
	else: return ""


func _on_Button_toggled(button_pressed: bool) -> void:
	if button_pressed and ready:
		get_node(tab_container).current_tab = get_index()
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP
