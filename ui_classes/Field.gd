tool
extends VBoxContainer
class_name Fields

export(String, MULTILINE) var text setget set_text, get_text
export(String, MULTILINE) var field_name setget set_field_name, get_field_name
export(bool) var secret setget set_secret, get_secret
export(String, MULTILINE) var placeholder_text setget set_placeholder_text, get_placeholder_text

onready var label: = $"%Label"
onready var verify_label: = $"%Verify"
onready var value = $"%Value"

func _ready():
	set("text", text)
	set("field_name", field_name)
	set("secret", secret)
	set("placeholder_text", placeholder_text)

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

func set_secret(new: bool):
	secret = new
	if !is_inside_tree():
		return
	value.secret = secret

func get_secret():
	if !is_inside_tree():
		return secret
	return value.secret
