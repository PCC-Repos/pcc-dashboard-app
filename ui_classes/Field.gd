tool
class_name Field
extends VBoxContainer

export(String, MULTILINE) var field_name setget set_field_name, get_field_name
export(String, MULTILINE) var placeholder_text setget set_placeholder_text, get_placeholder_text
export(String, MULTILINE) var text setget set_text, get_text
export(bool) var password setget set_password, get_password

var label: Label
var verify_label: Label
var value: LineEdit

onready var show_btn = $ValueEdit/Show


func _init() -> void:
	if is_inside_tree():
		_assign_vars()

func _ready() -> void:
	_assign_vars()

	set("text", text)
	set("field_name", field_name)
	set("password", password)
	set("placeholder_text", placeholder_text)

	show_btn.visible = password
	show_btn.connect("toggled", self, "_on_show_btn_toggled")
	value.connect("text_entered", self, "_on_value_text_entered")

func _assign_vars() -> void:
	label = $HB/FieldNameLabel
	verify_label = $HB/VerifyLabel
	value = $ValueEdit

func set_text(p_text: String) -> void:
	text = p_text
	if label:
		value.text = text

func get_text() -> String:
	return value.text

func set_field_name(p_field_name: String) -> void:
	field_name = p_field_name
	if label:
		label.text = field_name

func get_field_name() -> String:
	return label.text

func set_placeholder_text(p_placeholder_text: String) -> void:
	placeholder_text = p_placeholder_text
	if label:
		value.placeholder_text = placeholder_text

func get_placeholder_text() -> String:
	return value.placeholder_text

func set_password(p_password: bool) -> void:
	password = p_password
	if label:
		value.secret = password

func get_password() -> bool:
	return password

func _on_show_btn_toggled(button_pressed: bool) -> void:
	password = not button_pressed

func _on_value_text_entered(_new_text: String) -> void:
	if focus_next:
		get_node(focus_next).grab_focus()
