tool
extends EditorPlugin

var tab

var custom_protocol = preload("res://addons/file_protocols/custom_protocols.tscn")

func _enter_tree():
	var project_setting_editor = _get_node_by_type(get_editor_interface().get_base_control(), "ProjectSettingsEditor")
	var tabs = project_setting_editor.get_tabs()
	tab = custom_protocol.instance()
	tab.name = "Custom Protocols"
	tabs.add_child(tab)
	


func _exit_tree():
	var project_setting_editor = _get_node_by_type(get_editor_interface().get_base_control(), "ProjectSettingsEditor")
	var tabs = project_setting_editor.get_tabs()
	tabs.remove_child(tab)
	tab.queue_free()


func _get_node_by_type(node: Node, type):
	var return_node
	for child in node.get_children():
		if child.get_class() == type:
			return child
		else:
			return_node = _get_node_by_type(child, type)
	return return_node
