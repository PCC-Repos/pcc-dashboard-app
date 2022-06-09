extends Button

export var tab_container: NodePath

onready var ready: = true

func _get_configuration_warning() -> String:
	if not tab_container: return "You have not set the `tab_container` property"
	else: return ""


func _on_Button_toggled(button_pressed: bool) -> void:
	if button_pressed and ready:
		get_node(tab_container).current_tab = get_index()
