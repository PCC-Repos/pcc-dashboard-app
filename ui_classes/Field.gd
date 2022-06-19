tool
extends VBoxContainer
class_name Fields

export(String, MULTILINE) var field_name setget set_field_name, get_field_name
export(String, MULTILINE) var placeholder_text setget set_placeholder_text, get_placeholder_text
export(String, MULTILINE) var text setget set_text, get_text
export(bool) var password setget set_password, get_password

onready var label: = $"%Label"
onready var verify_label: = $"%Verify"
onready var value = $"%Value"

func _ready():
	set("text", text)
	set("field_name", field_name)
	set("password", password)
	set("placeholder_text", placeholder_text)
	pass

	value.get_node("Show").visible = password

func set_text(new: String):
	text = new
	if !is_inside_tree():
		return
	value.text = text

func get_text():
	if !is_inside_tree():
		return text
	return value.text

func set_field_name(new: String):
	field_name = new
	if !is_inside_tree():
		return
	label.text = field_name

func get_field_name():
	if !is_inside_tree():
		return field_name
	return label.text

func set_placeholder_text(new: String):
	placeholder_text = new
	if !is_inside_tree():
		return
	value.placeholder_text = placeholder_text

func get_placeholder_text():
	if !is_inside_tree():
		return placeholder_text
	return value.placeholder_text

func set_password(new: bool):
	password = new
	if !is_inside_tree():
		return
	value.secret = password

func get_password():
	if !is_inside_tree():
		return password
	return value.secret


func _on_Show_toggled(button_pressed: bool) -> void:
	self.password = not button_pressed


func _on_Value_text_entered(_new_text: String) -> void:
	if focus_next:
		get_node(focus_next).grab_focus()
